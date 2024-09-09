package storage

import (
	"net/http"

	"github.com/go-chi/chi/v5"
)

type StorageStore interface {
}

type service struct {
	handler   http.Handler
	storageStore StorageStore
}

func NewService(storageStore StorageStore) http.Handler {
	r := chi.NewRouter()
	s := service{
		handler:   r,
		storageStore: storageStore,
	}

	return s
}

func (s service) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	s.handler.ServeHTTP(w, r)
}
