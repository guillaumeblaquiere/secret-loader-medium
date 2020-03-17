package main

import (
	"fmt"
	"github.com/gorilla/mux"
	"log"
	"net/http"
	"os"
)

func main() {
	router := InitializeRouter()
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", port), router))
}

func InitializeRouter() *mux.Router {
	// StrictSlash is true => redirect /cars/ to /cars
	router := mux.NewRouter().StrictSlash(true)
	router.Methods("GET").Path("/").HandlerFunc(ReadEnvVar)
	return router
}

// Return all the environment variable in the current system
func ReadEnvVar(w http.ResponseWriter, r *http.Request) {
	e := ""
	for _, env := range os.Environ() {
		e += env + "\n"
	}
	fmt.Fprint(w, e)
}
