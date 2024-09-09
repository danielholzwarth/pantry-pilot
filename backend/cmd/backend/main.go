package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"

	"pantry-pilot/internal/api/item"
	storageMiddleware "pantry-pilot/internal/api/middleware"
	"pantry-pilot/internal/api/storage"
	"pantry-pilot/internal/api/user_account"
	"pantry-pilot/internal/pkg/storage/postgres"

	"github.com/go-chi/chi/v5"
)

var commitHash string
var databaseDSN = "postgres://postgres:postgres@localhost/postgres?sslmode=disable&connect_timeout=3"

func main() {
	log.Printf("Starting Backend %s\n", commitHash)

	if err := run(); err != nil {
		log.Println(err)
	}

}

func run() error {
	var dsn = os.Getenv("FLEXUS_DATABASE_DSN")
	if dsn != "" {
		databaseDSN = dsn
	}

	r := chi.NewRouter()

	db, err := postgres.New(databaseDSN)
	if err != nil {
		return fmt.Errorf("connecting to postgres: %w", err)
	}

	middlewareService := storageMiddleware.NewService(db)

	r.Mount("/user_accounts", user_account.NewService(db))
	r.Mount("/items", middlewareService.ValidateJWT(item.NewService(db)))
	r.Mount("/storages", middlewareService.ValidateJWT(storage.NewService(db)))

	srv := &http.Server{
		Addr:    ":8080",
		Handler: r,
	}

	srvErrChan := make(chan error, 1)
	go func() {
		if err := srv.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			srvErrChan <- err
		}
	}()

	signalChan := make(chan os.Signal, 1)
	signal.Notify(signalChan, os.Interrupt)
	select {
	case err := <-srvErrChan:
		return err
	case sig := <-signalChan:
		log.Printf("received %s\n", sig)
	}

	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		return fmt.Errorf("shutting down server: %w", err)
	}
	return nil
}
