package types

type Item struct {
	ID             int    `json:"id"`
	StorageID      int    `json:"storageID"`
	Name           string `json:"name"`
	Quantity       int    `json:"quantity"`
	TargetQuantity int    `json:"targetQuantity"`
	Details        string `json:"details"`
	Barcode        string `json:"barcode"`
}

type PostItemRequest struct {
	UserAccountID  int    `json:"userAccountID"`
	StorageID      int    `json:"storageID"`
	Name           string `json:"name"`
	Quantity       int    `json:"quantity"`
	TargetQuantity int    `json:"targetQuantity"`
	Details        string `json:"details"`
	Barcode        string `json:"barcode"`
}

type PatchItemRequest struct {
	UserAccountID  int    `json:"userAccountID"`
	ID             int    `json:"id"`
	OldStorageID   int    `json:"oldStorageID"`
	StorageID      int    `json:"storageID"`
	Name           string `json:"name"`
	Quantity       int    `json:"quantity"`
	TargetQuantity int    `json:"targetQuantity"`
	Details        string `json:"details"`
	Barcode        string `json:"barcode"`
}

type DeleteItemRequest struct {
	UserAccountID int `json:"userAccountID"`
	ID            int `json:"id"`
}
