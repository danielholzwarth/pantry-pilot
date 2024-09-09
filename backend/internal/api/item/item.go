package item

import (
	"net/http"

	"github.com/go-chi/chi/v5"
)

type ItemStore interface {
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

	return s
}

func (s service) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	s.handler.ServeHTTP(w, r)
}
