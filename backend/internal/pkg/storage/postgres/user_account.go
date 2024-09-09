package postgres

import (
	"database/sql"
	"errors"
	"pantry-pilot/internal/types"

	"golang.org/x/crypto/bcrypt"
)

func (db DB) CreateUserAccount(createUserRequest types.CreateUserRequest) (types.UserAccount, error) {
	emailAlreadyExists, err := GetEmailAlreadyExists(db, createUserRequest.Email)
	if err != nil {
		return types.UserAccount{}, err
	}

	if emailAlreadyExists {
		return types.UserAccount{}, errors.New("account with this email already exists")
	}

	tx, err := db.pool.Begin()
	if err != nil {
		return types.UserAccount{}, err
	}
	defer func() {
		if err != nil {
			tx.Rollback()
			return
		}
		err = tx.Commit()
	}()

	query := `
        INSERT INTO user_account (email, password, created_at)
        VALUES ($1, $2, NOW())
        RETURNING id, created_at;
    `

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(createUserRequest.Password), bcrypt.DefaultCost)
	if err != nil {
		return types.UserAccount{}, err
	}

	var userAccount types.UserAccount
	userAccount.Email = createUserRequest.Email
	userAccount.Password = hashedPassword

	err = tx.QueryRow(query, createUserRequest.Email, hashedPassword).Scan(&userAccount.Email, &userAccount.CreatedAt)
	if err != nil {
		return types.UserAccount{}, err
	}

	return userAccount, nil
}

func GetEmailAlreadyExists(db DB, email string) (bool, error) {
	var userCount int

	query := `
        SELECT COUNT(*)
        FROM user_account
        WHERE email = $1;
    `

	err := db.pool.QueryRow(query, email).Scan(&userCount)
	if err != nil {
		return false, err
	}
	return userCount > 0, nil
}

func (db DB) LoginUserAccount(loginUserRequest types.LoginUserRequest) (types.UserAccount, error) {
	var userAccount types.UserAccount

	query := `
        SELECT *
        FROM user_account
        WHERE email = $1;
    `

	err := db.pool.QueryRow(query, loginUserRequest.Email).Scan(
		&userAccount.ID,
		&userAccount.Email,
		&userAccount.Password,
		&userAccount.CreatedAt,
	)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return types.UserAccount{}, errors.New("user not found")
		}
		return types.UserAccount{}, err
	}

	err = bcrypt.CompareHashAndPassword([]byte(userAccount.Password), []byte(loginUserRequest.Password))
	if err != nil {
		return types.UserAccount{}, errors.New("incorrect password")
	}

	return userAccount, nil
}

func (db DB) ValidatePasswordByID(userAccountID int, password string) error {
	var storedPassword []byte

	query := `
        SELECT password
        FROM user_account
        WHERE id = $1;
    `

	err := db.pool.QueryRow(query, userAccountID).Scan(&storedPassword)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return errors.New("user not found")
		}
		return err
	}

	err = bcrypt.CompareHashAndPassword([]byte(storedPassword), []byte(password))
	return err
}
