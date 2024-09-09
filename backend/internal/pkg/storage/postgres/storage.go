package postgres

import (
	"errors"
	"pantry-pilot/internal/types"
)

func (db DB) PostStorage(request types.PostStorageRequest) (types.PostStorageResponse, error) {
	//Check if already exists
	query := `
		SELECT EXISTS(
			SELECT 1 
			FROM storage
			WHERE name = $1 AND user_account_id = $2
		);
	`

	var exists bool
	err := db.pool.QueryRow(query, request.Name, request.UserAccountID).Scan(&exists)
	if err != nil {
		return types.PostStorageResponse{}, err
	}

	if exists {
		return types.PostStorageResponse{}, errors.New("storage exists already")
	}

	//Create Storage
	var postStorageResponse types.PostStorageResponse

	query = `
		INSERT INTO storage (name, user_account_id, created_at, updated_at)
		VALUES ($1, $2, Now(), Now())
		RETURNING id, name, user_account_id, created_at, updated_at;
	`

	err = db.pool.QueryRow(query, request.Name, request.UserAccountID).Scan(
		&postStorageResponse.ID,
		&postStorageResponse.Name,
		&postStorageResponse.UserAccountID,
		&postStorageResponse.CreatedAt,
		&postStorageResponse.UpdatedAt)
	if err != nil {
		return types.PostStorageResponse{}, err
	}

	return postStorageResponse, nil
}

func (db DB) GetStorages(userAccountID int) ([]types.Storage, error) {
	var storages []types.Storage

	//Get all Storages
	query := `
        SELECT *
        FROM storage
		WHERE user_account_id = $1;
    `

	rows, err := db.pool.Query(query, userAccountID)
	if err != nil {
		return []types.Storage{}, err
	}
	defer rows.Close()

	for rows.Next() {
		var storage types.Storage

		err := rows.Scan(&storage.ID, &storage.Name, &storage.UserAccountID, &storage.UpdatedAt, &storage.CreatedAt)
		if err != nil {
			return []types.Storage{}, err
		}

		storages = append(storages, storage)
	}

	//Get all Items for each Storage
	query = `
		SELECT *
		FROM item
		WHERE storage_id = $1;
	`

	for _, v := range storages {
		rows, err := db.pool.Query(query, v.ID)
		if err != nil {
			return []types.Storage{}, err
		}
		defer rows.Close()

		for rows.Next() {
			var item types.Item

			err := rows.Scan(&item.ID, &item.StorageID, &item.Name, &item.Quantity, &item.TargetQuantity, &item.Details, &item.Barcode)
			if err != nil {
				return []types.Storage{}, err
			}

			v.Items = append(v.Items, item)
		}
	}

	return storages, err
}
