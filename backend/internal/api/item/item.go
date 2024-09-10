package item

import (
	"encoding/json"
	"net/http"
	"pantry-pilot/internal/types"

	"github.com/go-chi/chi/v5"
)

type ItemStore interface {
	PostItem(request types.PostItemRequest) (types.PostItemResponse, error)
	PatchItem(request types.PatchItemRequest) (types.PatchItemResponse, error)
}

type service struct {
	handler   http.Handler
	itemStore ItemStore
}

func NewService(itemStore ItemStore) http.Handler {
	r := chi.NewRouter()
	s := service{
		handler:   r,
		itemStore: itemStore,
	}

	r.Post("/", s.postItem())
	r.Patch("/", s.patchItem())

	return s
}

func (s service) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	s.handler.ServeHTTP(w, r)
}

func (s service) postItem() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		claims, ok := r.Context().Value(types.RequestorContextKey).(types.Claims)
		if !ok {
			http.Error(w, "Invalid requestor ID", http.StatusInternalServerError)
			return
		}

		var requestBody types.PostItemRequest
		requestBody.UserAccountID = claims.UserAccountID

		decoder := json.NewDecoder(r.Body)
		if err := decoder.Decode(&requestBody); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		if requestBody.StorageID <= 0 {
			http.Error(w, "Wrong input for storageID. Must be integer greater than 0", http.StatusBadRequest)
			println("Wrong input for storageID. Must be integer greater than 0")
			return
		}

		if requestBody.Name == "" {
			http.Error(w, "Name must not be empty", http.StatusBadRequest)
			println("Name must not be empty")
			return
		}

		item, err := s.itemStore.PostItem(requestBody)
		if err != nil {
			http.Error(w, "Failed to create Item", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		response, err := json.Marshal(item)
		if err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.WriteHeader(http.StatusCreated)
		w.Write(response)
	}
}

func (s service) patchItem() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		claims, ok := r.Context().Value(types.RequestorContextKey).(types.Claims)
		if !ok {
			http.Error(w, "Invalid requestor ID", http.StatusInternalServerError)
			return
		}

		var requestBody types.PatchItemRequest
		requestBody.UserAccountID = claims.UserAccountID

		decoder := json.NewDecoder(r.Body)
		if err := decoder.Decode(&requestBody); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		if requestBody.StorageID <= 0 {
			http.Error(w, "Wrong input for storageID. Must be integer greater than 0", http.StatusBadRequest)
			println("Wrong input for storageID. Must be integer greater than 0")
			return
		}

		//TODO Get entire object and patch db entry

		item, err := s.itemStore.PatchItem(requestBody)
		if err != nil {
			http.Error(w, "Failed to patch Item", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		response, err := json.Marshal(item)
		if err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.WriteHeader(http.StatusOK)
		w.Write(response)
	}
}
