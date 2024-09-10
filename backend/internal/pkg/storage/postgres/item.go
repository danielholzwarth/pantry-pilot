package postgres

import (
	"errors"
	"pantry-pilot/internal/types"
)

func (db DB) PostItem(request types.PostItemRequest) (types.PostItemResponse, error) {
	//Check if item already exists
	query := `
		SELECT EXISTS(
			SELECT 1 
			FROM item i
			JOIN storage s ON i.storage_id = s.id
			WHERE i.name = $1 AND i.storage_id = $2 AND s.user_account_id = $3
		);
	`

	var exists bool
	err := db.pool.QueryRow(query, request.Name, request.StorageID, request.UserAccountID).Scan(&exists)
	if err != nil {
		return types.PostItemResponse{}, err
	}

	if exists {
		return types.PostItemResponse{}, errors.New("item exists already")
	}

	//Create Item
	var postItemResponse types.PostItemResponse

	query = `
		INSERT INTO item (storage_id, name, quantity, target_quantity, details, barcode)
		VALUES ($1, $2, $3, $4, $5, $6)
		RETURNING id, storage_id, name, quantity, target_quantity, details, barcode;
	`

	err = db.pool.QueryRow(query, request.StorageID, request.Name, request.Quantity, request.TargetQuantity, request.Details, request.Barcode).Scan(
		&postItemResponse.ID,
		&postItemResponse.StorageID,
		&postItemResponse.Name,
		&postItemResponse.Quantity,
		&postItemResponse.TargetQuantity,
		&postItemResponse.Details,
		&postItemResponse.Barcode,
	)
	if err != nil {
		return types.PostItemResponse{}, err
	}

	return postItemResponse, nil
}

func (db DB) PatchItem(request types.PatchItemRequest) (types.PatchItemResponse, error) {
	return types.PatchItemResponse{}, nil
}
