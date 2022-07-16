package main

import (
	"fmt"
	"log"
	"os"

	"github.com/XanderWatson/the-key-thing/routes"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/joho/godotenv"
)

func main() {
	err := godotenv.Load()

	if err != nil {
		fmt.Println(err)
	}

	app := fiber.New()
	app.Use(cors.New(cors.Config{
		AllowHeaders: "Origin, Content-Type, Accept",
	}))

	app.Use(logger.New())

	setupRoutes(app)

	log.Fatal(app.Listen(os.Getenv("APP_PORT")))
}

func setupRoutes(app *fiber.App) {
	app.Post("/users/signup", routes.SignUp)
	app.Get("/users/login", routes.Login)
	app.Get("/users/details", routes.GetUser)
	app.Put("/users", routes.UpdateUser)
	app.Delete("/users", routes.DeleteUser)

	app.Post("/accounts", routes.AddAccount)
	app.Get("/accounts", routes.GetAccounts)
	app.Put("/accounts", routes.UpdateAccount)
	app.Delete("/accounts", routes.DeleteAccount)
}
