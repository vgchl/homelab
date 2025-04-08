package main

import (
	"embed"
	_ "embed"
	"errors"
	"github.com/anatol/tang.go"
	"github.com/lestrrat-go/jwx/jwk"
	"log"
	"net/http"
	"os"
)

//go:embed jwks/*
var fs embed.FS

func main() {
	keySet := tang.NewKeySet()

	entries, err := fs.ReadDir("jwks")
	if err != nil {
		log.Print("Failed to read embedded keys dir: ", err)
		os.Exit(1)
	}
	for _, entry := range entries {
		file, err := fs.ReadFile("jwks/" + entry.Name())
		if err != nil {
			log.Print("Failed to read key file: ", err)
			os.Exit(2)
		}
		key, err := jwk.ParseKey(file)
		if err != nil {
			log.Print("Failed to parse key: ", err)
			log.Print(err)
			os.Exit(3)
		}
		err = keySet.AppendKey(key, true)
		if err != nil {
			log.Print("Failed to add key to key set: ", err)
			os.Exit(4)
		}
	}
	err = keySet.RecomputeAdvertisements()
	if err != nil {
		log.Print("Failed to compute advertisements: ", err)
		os.Exit(5)
	}

	srv := tang.NewServer()

	log.Print("Running tang...")
	srv.Keys = keySet
	srv.Addr = "0.0.0.0:9999"
	err = srv.ListenAndServe()
	if err != nil && !errors.Is(err, http.ErrServerClosed) {
		log.Print("An error occurred running the server: ", err)
		os.Exit(10)
	}

}
