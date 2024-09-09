package types

import "time"

type Storage struct {
	ID            int       `json:"id"`
	Name          string    `json:"name"`
	UserAccountID int       `json:"userAccountID"`
	UpdatedAt     time.Time `json:"updatedAt"`
	CreatedAt     time.Time `json:"createdAt"`
	Items         []Item    `json:"items"`
}

type PostStorageRequest struct {
	Name          string `json:"name"`
	UserAccountID int    `json:"userAccountID"`
}

type PostStorageResponse struct {
	ID            int       `json:"id"`
	Name          string    `json:"name"`
	UserAccountID int       `json:"userAccountID"`
	UpdatedAt     time.Time `json:"updatedAt"`
	CreatedAt     time.Time `json:"createdAt"`
	Items         []Item    `json:"items"`
}
