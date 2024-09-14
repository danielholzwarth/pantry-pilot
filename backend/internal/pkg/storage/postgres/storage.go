package postgres

import (
	"database/sql"
	"errors"
	"pantry-pilot/internal/types"
)

func (db DB) PostStorage(request types.PostStorageRequest) error {
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
		return err
	}

	if exists {
		return errors.New("storage exists already")
	}

	query = `
		INSERT INTO storage (name, user_account_id, created_at, updated_at)
		VALUES ($1, $2, Now(), Now());
	`

	_, err = db.pool.Exec(query, request.Name, request.UserAccountID)

	return err
}

func (db DB) GetStorages(request types.GetStoragesRequest) ([]types.Storage, error) {
	var storages []types.Storage

	//Get all Storages
	query := `
        SELECT *
        FROM storage
		WHERE user_account_id = $1;
    `

	rows, err := db.pool.Query(query, request.UserAccountID)
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
		WHERE storage_id = $1
		ORDER BY name ASC;
	`

	for i := range storages {
		rows, err := db.pool.Query(query, storages[i].ID)
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

			storages[i].Items = append(storages[i].Items, item)
		}
	}

	return storages, err
}

func (db DB) GetStoragesSearch(request types.GetStoragesSearchRequest) ([]types.Storage, error) {
	var storages []types.Storage

	//Get all Storages
	query := `
        SELECT *
        FROM storage
		WHERE user_account_id = $1;
    `

	rows, err := db.pool.Query(query, request.UserAccountID)
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

	//Get all Items for each Storage with matching Keyword
	query = `
		SELECT *
		FROM item
		WHERE storage_id = $1 AND (LOWER(name) LIKE '%' || LOWER($2) || '%' OR LOWER(details) LIKE '%' || LOWER($2) || '%')
		ORDER BY name ASC;
	`

	var filledStorages []types.Storage

	println("Keyword: ", request.Keyword)

	for i := range storages {
		rows, err := db.pool.Query(query, storages[i].ID, request.Keyword)
		if err != nil {
			return []types.Storage{}, err
		}

		for rows.Next() {
			var item types.Item

			err := rows.Scan(&item.ID, &item.StorageID, &item.Name, &item.Quantity, &item.TargetQuantity, &item.Details, &item.Barcode)
			if err != nil {
				return []types.Storage{}, err
			}

			storages[i].Items = append(storages[i].Items, item)
		}
		rows.Close()

		//Remove all Storages with no Items
		if len(storages[i].Items) > 0 {
			filledStorages = append(filledStorages, storages[i])
		}
	}

	return filledStorages, nil
}

func (db DB) PatchStorage(request types.PatchStorageRequest) error {
	query := `
		UPDATE storage
		SET name = $1
		WHERE id = $2 AND user_account_id = $3;
	`

	_, err := db.pool.Exec(query, request.Name, request.StorageID, request.UserAccountID)
	if errors.Is(err, sql.ErrNoRows) {
		return errors.New("storage not found")
	}

	return err
}

func (db DB) DeleteStorage(request types.DeleteStorageRequest) error {
	query := `
		DELETE
		FROM storage
		WHERE id = $1 AND user_account_id = $2;
	`

	_, err := db.pool.Exec(query, request.StorageID, request.UserAccountID)

	return err
}
