package item

import (
	"encoding/json"
	"net/http"
	"pantry-pilot/internal/types"
	"strconv"

	"github.com/go-chi/chi/v5"
)

type ItemStore interface {
	PostItem(request types.PostItemRequest) error
	PatchItem(request types.PatchItemRequest) error
	DeleteItem(request types.DeleteItemRequest) error
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
	r.Patch("/{itemID}", s.patchItem())
	r.Delete("/{itemID}", s.deleteItem())

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

		if requestBody.Quantity < 0 {
			http.Error(w, "Wrong input for quantity. Must be integer equal or greater than 0", http.StatusBadRequest)
			println("Wrong input for quantity. Must be integer equal or greater than 0")
			return
		}

		err := s.itemStore.PostItem(requestBody)
		if err != nil {
			http.Error(w, "Failed to create Item", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.WriteHeader(http.StatusCreated)
	}
}

func (s service) patchItem() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		claims, ok := r.Context().Value(types.RequestorContextKey).(types.Claims)
		if !ok {
			http.Error(w, "Invalid requestor ID", http.StatusInternalServerError)
			return
		}

		var request types.PatchItemRequest
		request.UserAccountID = claims.UserAccountID

		itemIDValue := chi.URLParam(r, "itemID")
		itemID, err := strconv.Atoi(itemIDValue)
		if err != nil || itemID <= 0 {
			http.Error(w, "Wrong input for itemID. Must be integer greater than 0.", http.StatusBadRequest)
			println(err.Error())
			return
		}

		request.ID = itemID

		decoder := json.NewDecoder(r.Body)
		if err := decoder.Decode(&request); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		if request.StorageID <= 0 {
			http.Error(w, "Wrong input for storageID. Must be integer greater than 0", http.StatusBadRequest)
			println("Wrong input for storageID. Must be integer greater than 0")
			return
		}

		if request.OldStorageID <= 0 {
			http.Error(w, "Wrong input for oldStorageID. Must be integer greater than 0", http.StatusBadRequest)
			println("Wrong input for oldStorageID. Must be integer greater than 0")
			return
		}

		if request.Name == "" {
			http.Error(w, "Name must not be empty", http.StatusBadRequest)
			println("Name must not be empty")
			return
		}

		if request.Quantity < 0 {
			http.Error(w, "Wrong input for quantity. Must be integer equal or greater than 0", http.StatusBadRequest)
			println("Wrong input for quantity. Must be integer equal or greater than 0")
			return
		}

		err = s.itemStore.PatchItem(request)
		if err != nil {
			http.Error(w, "Failed to patch Item", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.WriteHeader(http.StatusOK)
	}
}

func (s service) deleteItem() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		claims, ok := r.Context().Value(types.RequestorContextKey).(types.Claims)
		if !ok {
			http.Error(w, "Invalid requestor ID", http.StatusInternalServerError)
			return
		}

		var request types.DeleteItemRequest
		request.UserAccountID = claims.UserAccountID

		itemIDValue := chi.URLParam(r, "itemID")
		itemID, err := strconv.Atoi(itemIDValue)
		if err != nil || itemID <= 0 {
			http.Error(w, "Wrong input for itemID. Must be integer greater than 0.", http.StatusBadRequest)
			println(err.Error())
			return
		}

		request.ID = itemID

		err = s.itemStore.DeleteItem(request)
		if err != nil {
			http.Error(w, "Failed to delete Item", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.WriteHeader(http.StatusOK)
	}
}
