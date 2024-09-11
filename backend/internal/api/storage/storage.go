package storage

import (
	"encoding/json"
	"net/http"
	"pantry-pilot/internal/types"
	"strconv"

	"github.com/go-chi/chi/v5"
)

type StorageStore interface {
	PostStorage(request types.PostStorageRequest) error
	GetStorages(request types.GetStoragesRequest) ([]types.Storage, error)
	PatchStorage(request types.PatchStorageRequest) error
	DeleteStorage(request types.DeleteStorageRequest) error
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
	r.Patch("/{storageID}", s.patchStorage())
	r.Delete("/{storageID}", s.deleteStorage())

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

		var request types.PostStorageRequest
		request.UserAccountID = claims.UserAccountID

		decoder := json.NewDecoder(r.Body)
		if err := decoder.Decode(&request); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		if request.Name == "" {
			http.Error(w, "Name must not be empty", http.StatusBadRequest)
			println("Name must not be empty")
			return
		}

		err := s.storageStore.PostStorage(request)
		if err != nil {
			http.Error(w, "Failed to create Storage", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.WriteHeader(http.StatusCreated)
	}
}

func (s service) getStorages() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		claims, ok := r.Context().Value(types.RequestorContextKey).(types.Claims)
		if !ok {
			http.Error(w, "Invalid requestor ID", http.StatusInternalServerError)
			return
		}

		var request types.GetStoragesRequest
		request.UserAccountID = claims.UserAccountID

		data, err := s.storageStore.GetStorages(request)
		if err != nil {
			http.Error(w, "Failed to get Storages", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		if data == nil {
			w.WriteHeader(http.StatusOK)
			w.Write(nil)
			return
		}

		response, err := json.Marshal(data)
		if err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.WriteHeader(http.StatusOK)
		w.Write(response)
	}
}

func (s service) patchStorage() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		claims, ok := r.Context().Value(types.RequestorContextKey).(types.Claims)
		if !ok {
			http.Error(w, "Invalid requestor ID", http.StatusInternalServerError)
			return
		}

		var request types.PatchStorageRequest
		request.UserAccountID = claims.UserAccountID

		storageIDValue := chi.URLParam(r, "storageID")
		storageID, err := strconv.Atoi(storageIDValue)
		if err != nil || storageID <= 0 {
			http.Error(w, "Wrong input for storageID. Must be integer greater than 0.", http.StatusBadRequest)
			println(err.Error())
			return
		}

		request.StorageID = storageID

		decoder := json.NewDecoder(r.Body)
		if err := decoder.Decode(&request); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		if request.Name == "" {
			http.Error(w, "Name must not be empty", http.StatusBadRequest)
			println("Name must not be empty")
			return
		}

		err = s.storageStore.PatchStorage(request)
		if err != nil {
			http.Error(w, "Failed to patch Storage", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.WriteHeader(http.StatusOK)
	}
}

func (s service) deleteStorage() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		claims, ok := r.Context().Value(types.RequestorContextKey).(types.Claims)
		if !ok {
			http.Error(w, "Invalid requestor ID", http.StatusInternalServerError)
			return
		}

		var request types.DeleteStorageRequest
		request.UserAccountID = claims.UserAccountID

		storageIDValue := chi.URLParam(r, "storageID")
		storageID, err := strconv.Atoi(storageIDValue)
		if err != nil || storageID <= 0 {
			http.Error(w, "Wrong input for storageID. Must be integer greater than 0.", http.StatusBadRequest)
			println(err.Error())
			return
		}

		request.StorageID = storageID

		err = s.storageStore.DeleteStorage(request)
		if err != nil {
			http.Error(w, "Failed to delete Storage", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.WriteHeader(http.StatusOK)
	}
}
