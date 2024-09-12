package types

import "time"

type UserAccount struct {
	ID        int       `json:"id"`
	Email     string    `json:"email"`
	Password  []byte    `json:"password"`
	CreatedAt time.Time `json:"createdAt"`
}

type PostUserRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type PostUserResponse struct {
	UserAccountID int    `json:"userAccountID"`
	Email         string `json:"email"`
}

type LoginUserRequest struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type LoginUserResponse struct {
	UserAccountID int    `json:"userAccountID"`
	Email         string `json:"email"`
}
