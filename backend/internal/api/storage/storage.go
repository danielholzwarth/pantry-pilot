package storage

import (
	"encoding/json"
	"net/http"
	"pantry-pilot/internal/types"

	"github.com/go-chi/chi/v5"
)

type StorageStore interface {
	PostStorage(request types.PostStorageRequest) (types.PostStorageResponse, error)
	GetStorages(userAccountID int) ([]types.Storage, error)
}

type service struct {
	handler      http.Handler
	storageStore StorageStore
}

func NewService(storageStore StorageStore) http.Handler {
	r := chi.NewRouter()
	s := service{
		handler:      r,
		storageStore: storageStore,
	}

	r.Post("/", s.postStorage())
	r.Get("/", s.getStorages())

	return s
}

func (s service) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	s.handler.ServeHTTP(w, r)
}

func (s service) postStorage() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		claims, ok := r.Context().Value(types.RequestorContextKey).(types.Claims)
		if !ok {
			http.Error(w, "Invalid requestor ID", http.StatusInternalServerError)
			return
		}

		var requestBody types.PostStorageRequest
		requestBody.UserAccountID = claims.UserAccountID

		decoder := json.NewDecoder(r.Body)
		if err := decoder.Decode(&requestBody); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		if requestBody.Name == "" {
			http.Error(w, "Name must not be empty", http.StatusBadRequest)
			println("Name must not be empty")
			return
		}

		storage, err := s.storageStore.PostStorage(requestBody)
		if err != nil {
			http.Error(w, "Failed to create Storage", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		response, err := json.Marshal(storage)
		if err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusCreated)
		w.Write(response)
	}
}

func (s service) getStorages() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		claims, ok := r.Context().Value(types.RequestorContextKey).(types.Claims)
		if !ok {
			http.Error(w, "Invalid requestor ID", http.StatusInternalServerError)
			return
		}

		storages, err := s.storageStore.GetStorages(claims.UserAccountID)
		if err != nil {
			http.Error(w, "Failed to get Storages", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		response, err := json.Marshal(storages)
		if err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusCreated)
		w.Write(response)
	}
}
