package postgres

import (
	"database/sql"
	"errors"
	"pantry-pilot/internal/types"

	"golang.org/x/crypto/bcrypt"
)

func (db DB) PostUserAccount(createUserRequest types.PostUserRequest) (types.PostUserResponse, error) {
	exists, err := GetEmailAlreadyExists(db, createUserRequest.Email)
	if err != nil {
		return types.PostUserResponse{}, err
	}

	if exists {
		return types.PostUserResponse{}, errors.New("account with this email already exists")
	}

	query := `
        INSERT INTO user_account (email, password, created_at)
        VALUES ($1, $2, NOW())
        RETURNING id, email, created_at;
    `

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(createUserRequest.Password), bcrypt.DefaultCost)
	if err != nil {
		return types.PostUserResponse{}, err
	}

	var postUserResponse types.PostUserResponse

	err = db.pool.QueryRow(query, createUserRequest.Email, hashedPassword).Scan(&postUserResponse.UserAccountID, &postUserResponse.Email)
	if err != nil {
		return types.PostUserResponse{}, err
	}

	return postUserResponse, nil
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

func (db DB) LoginUserAccount(loginUserRequest types.LoginUserRequest) (types.LoginUserResponse, error) {
	var loginUserResponse types.LoginUserResponse
	var hashedPassword []byte

	query := `
        SELECT *
        FROM user_account
        WHERE email = $1;
    `

	err := db.pool.QueryRow(query, loginUserRequest.Email).Scan(
		&loginUserResponse.UserAccountID,
		&loginUserResponse.Email,
		&hashedPassword,
	)

	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return types.LoginUserResponse{}, errors.New("user not found")
		}
		return types.LoginUserResponse{}, err
	}

	err = bcrypt.CompareHashAndPassword([]byte(hashedPassword), []byte(loginUserRequest.Password))
	if err != nil {
		return types.LoginUserResponse{}, errors.New("incorrect password")
	}

	return loginUserResponse, nil
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
