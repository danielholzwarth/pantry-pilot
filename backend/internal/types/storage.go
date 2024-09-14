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

type GetStoragesRequest struct {
	UserAccountID int `json:"userAccountID"`
}

type GetStoragesSearchRequest struct {
	UserAccountID int    `json:"userAccountID"`
	Keyword       string `json:"keyword"`
}

type PatchStorageRequest struct {
	StorageID     int    `json:"storageID"`
	Name          string `json:"name"`
	UserAccountID int    `json:"userAccountID"`
}

type DeleteStorageRequest struct {
	StorageID     int `json:"storageID"`
	UserAccountID int `json:"userAccountID"`
}
