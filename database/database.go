package database

import (
	"context"
	"github.com/go-redis/redis"
	"os"
)

var Ctx = context.Background()

func CreateClient(dbNo int) *redis.Client {
	rdb := redis.NewClient(&redis.Options{
		Addr:     os.Getenv("REDIS_HOST") + ":" + os.Getenv("REDIS_PORT"),
		DB:       dbNo,
		Password: os.Getenv("REDIS_PASSWORD"),
	})

	return rdb
}
