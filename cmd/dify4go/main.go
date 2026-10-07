package main

import (
	"encoding/json"
	"log"

	"github.com/gin-gonic/gin"
)

func main() {
	gin.SetMode(gin.ReleaseMode)
	router := gin.New()
	router.Use(gin.Recovery())
	router.GET("/healthz", func(c *gin.Context) {
		c.Header("Content-Type", "application/json; charset=utf-8")
		_ = json.NewEncoder(c.Writer).Encode(map[string]string{"status": "ok"})
	})
	if err := router.Run(":8080"); err != nil {
		log.Fatal(err)
	}
}
