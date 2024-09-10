package user_account

import (
	"encoding/json"
	"net/http"
	"pantry-pilot/internal/api/middleware"
	"pantry-pilot/internal/types"

	"github.com/go-chi/chi/v5"
)

type UserAccountStore interface {
	PostUserAccount(createUserRequest types.PostUserRequest) (types.PostUserResponse, error)
	LoginUserAccount(loginUserRequest types.LoginUserRequest) (types.LoginUserResponse, error)
}

type service struct {
	handler          http.Handler
	userAccountStore UserAccountStore
}

func NewService(userAccountStore UserAccountStore) http.Handler {
	r := chi.NewRouter()
	s := service{
		handler:          r,
		userAccountStore: userAccountStore,
	}

	r.Post("/", s.postUserAccount())
	r.Get("/login", s.loginUserAccount())

	return s
}

func (s service) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	s.handler.ServeHTTP(w, r)
}

func (s service) postUserAccount() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var requestBody types.PostUserRequest

		decoder := json.NewDecoder(r.Body)
		if err := decoder.Decode(&requestBody); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			return
		}

		if requestBody.Email == "" {
			http.Error(w, "Email must not be empty", http.StatusBadRequest)
			println("Email must not be empty")
			return
		}

		if requestBody.Password == "" {
			http.Error(w, "Password must not be empty", http.StatusBadRequest)
			println("Password must not be empty")
			return
		}

		user, err := s.userAccountStore.PostUserAccount(requestBody)
		if err != nil {
			http.Error(w, "Failed to create User", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		jwtAccess, err := middleware.CreateAccessToken(user.ID, user.Email)
		if err != nil {
			http.Error(w, "Failed to create Access Token", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		jwtRefresh, err := middleware.CreateRefreshToken(user.ID, user.Email)
		if err != nil {
			http.Error(w, "Failed to create Refresh Token", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.Header().Add("storage-jwt-access", jwtAccess)
		w.Header().Add("storage-jwt-refresh", jwtRefresh)

		response, err := json.Marshal(user)
		if err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.WriteHeader(http.StatusCreated)
		w.Write(response)
	}
}

func (s service) loginUserAccount() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var requestBody types.LoginUserRequest

		decoder := json.NewDecoder(r.Body)
		if err := decoder.Decode(&requestBody); err != nil {
			http.Error(w, err.Error(), http.StatusBadRequest)
			println(err.Error())
			return
		}

		if requestBody.Email == "" {
			http.Error(w, "Email must not be empty", http.StatusBadRequest)
			println("Email must not be empty")
			return
		}

		if requestBody.Password == "" {
			http.Error(w, "Password must not be empty", http.StatusBadRequest)
			println("Password must not be empty")
			return
		}

		user, err := s.userAccountStore.LoginUserAccount(requestBody)
		if err != nil {
			http.Error(w, "Failed to login user", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		jwtAccess, err := middleware.CreateAccessToken(user.ID, user.Email)
		if err != nil {
			http.Error(w, "Failed to create Access Token", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		jwtRefresh, err := middleware.CreateRefreshToken(user.ID, user.Email)
		if err != nil {
			http.Error(w, "Failed to create Refresh Token", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.Header().Add("storage-jwt-access", jwtAccess)
		w.Header().Add("storage-jwt-refresh", jwtRefresh)

		response, err := json.Marshal(user)
		if err != nil {
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			println(err.Error())
			return
		}

		w.WriteHeader(http.StatusOK)
		w.Write(response)
	}
}
