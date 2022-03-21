package main

import (
	"context"
	"errors"
	"fmt"
	wiino "github.com/RiiConnect24/wiino/golang"
	"github.com/jackc/pgx/v4/pgxpool"
	"log"
	"net/http"
	"strconv"
)

const (
	InsertVote = `INSERT INTO votes 
					(type_cd, question_id, wii_no, country_id, region_id, ans_cnt)
					VALUES ($1, $2, $3, $4, $5, $6)`
	InsertSuggestion = `INSERT INTO suggestions
						(country_code, region_code, language_code, content, choice1, choice2, wii_no)
						VALUES ($1, $2, $3, $4, $5, $6, $7)`
)

var (
	InvalidData = errors.New("invalid data")
)

var pool *pgxpool.Pool
var ctx = context.Background()

func checkError(err error) {
	if err != nil {
		log.Fatalf("Everybody Votes Channel server has encountered a fatal error! Reason: %v\n", err)
	}
}

func main() {
	// Get config
	config := GetConfig()

	// Start SQL
	dbString := fmt.Sprintf("postgres://%s:%s@%s/%s", config.Username, config.Password, config.DatabaseAddress, config.DatabaseName)
	dbConf, err := pgxpool.ParseConfig(dbString)
	checkError(err)
	pool, err = pgxpool.ConnectConfig(ctx, dbConf)
	checkError(err)

	http.HandleFunc("/cgi-bin/vote.cgi", handleVote)
	http.HandleFunc("/cgi-bin/suggest.cgi", handleSuggestion)

	err = http.ListenAndServe(config.Address, nil)
	checkError(err)
}

func handleVote(w http.ResponseWriter, r *http.Request) {
	wiiNumber := convertToUint(w, r.URL.Query().Get("wiiNo"))
	if wiino.NWC24CheckUserID(wiiNumber) != 0 {
		w.WriteHeader(http.StatusBadRequest)
		panic(InvalidData)
	}

	typeCD := convertToUint(w, r.URL.Query().Get("typeCD"))
	countryID := convertToUint(w, r.URL.Query().Get("countryID"))
	questionID := convertToUint(w, r.URL.Query().Get("questionID"))
	regionID := convertToUint(w, r.URL.Query().Get("regionID"))
	ansCNT := convertToUint(w, r.URL.Query().Get("ansCNT"))

	_, err := pool.Exec(ctx, InsertVote, typeCD, questionID, wiiNumber, countryID, regionID, ansCNT)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		panic(err)
	}

	w.Write([]byte("100"))
}

func handleSuggestion(w http.ResponseWriter, r *http.Request) {
	err := r.ParseForm()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		panic(err)
	}

	wiiNumber := convertToUint(w, r.FormValue("wiiNo"))
	if wiino.NWC24CheckUserID(wiiNumber) != 0 {
		w.WriteHeader(http.StatusBadRequest)
		panic(InvalidData)
	}

	countryCode := convertToUint(w, r.FormValue("countryID"))
	regionCode := convertToUint(w, r.FormValue("regionID"))
	languageCode := convertToUint(w, r.FormValue("langCD"))
	content := r.FormValue("content")
	choice1 := r.FormValue("choice1")
	choice2 := r.FormValue("choice2")
	if content == "" || choice1 == "" || choice2 == "" {
		w.WriteHeader(http.StatusBadRequest)
		panic(InvalidData)
	}

	_, err = pool.Exec(ctx, InsertSuggestion, countryCode, regionCode, languageCode, content, choice1, choice2, wiiNumber)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		panic(err)
	}

	w.Write([]byte("100"))
}

func convertToUint(w http.ResponseWriter, param string) uint64 {
	returnValue, err := strconv.ParseUint(param, 10, 64)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		panic(err)
	}

	return returnValue
}