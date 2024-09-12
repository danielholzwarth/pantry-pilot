package postgres

import (
	"database/sql"
	"errors"
	"pantry-pilot/internal/types"
)

func (db DB) PostItem(request types.PostItemRequest) error {
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
		return err
	}

	if exists {
		return errors.New("item exists already")
	}

	query = `
		INSERT INTO item (storage_id, name, quantity, target_quantity, details, barcode)
		VALUES ($1, $2, $3, $4, $5, $6);
	`

	_, err = db.pool.Exec(query, request.StorageID, request.Name, request.Quantity, request.TargetQuantity, request.Details, request.Barcode)
	return err
}

func (db DB) PatchItem(request types.PatchItemRequest) error {
	query := `
		UPDATE item i
		JOIN storage s ON s.id = i.storage_id 
		SET i.name = $1, i.quantity = $2, i.target_quantity = $3, i.details = $4, i.barcode = $5
		WHERE i.id = $6 AND i.storage_id = $7 AND s.user_Account_id = $8;
	`

	_, err := db.pool.Exec(query, request.Name, request.Quantity, request.TargetQuantity, request.Details, request.Barcode, request.ID, request.StorageID, request.UserAccountID)
	if errors.Is(err, sql.ErrNoRows) {
		return errors.New("item not found")
	}

	return err
}

func (db DB) DeleteItem(request types.DeleteItemRequest) error {
	query := `
		DELETE
		FROM item i
		JOIN storage s ON s.id = i.storage_id
		WHERE i.id = $1 AND s.user_account_id = $2;
	`

	_, err := db.pool.Exec(query, request.ID, request.UserAccountID)

	return err
}
