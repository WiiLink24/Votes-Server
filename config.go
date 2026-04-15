package main

import (
	"encoding/xml"
	"os"
)

type Config struct {
	Username        string `xml:"username"`
	Password        string `xml:"password"`
	DatabaseAddress string `xml:"databaseAddress"`
	DatabaseName    string `xml:"databaseName"`
	Address         string `xml:"address"`
}

func GetConfig() Config {
	data, err := os.ReadFile("config.xml")
	checkError(err)

	var config Config
	err = xml.Unmarshal(data, &config)
	checkError(err)

	return config
}
