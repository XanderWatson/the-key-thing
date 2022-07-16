package routes

import (
	"encoding/json"

	"github.com/XanderWatson/the-key-thing/database"
	"github.com/XanderWatson/the-key-thing/schemas"
	"github.com/gofiber/fiber/v2"
)

func SignUp(c *fiber.Ctx) error {
	userDB := database.CreateClient(0)

	user := new(schemas.User)
	if err := c.BodyParser(user); err != nil {
		return err
	}

	userJSON, err := json.Marshal(user)
	if err != nil {
		return err
	}

	var userInterface map[string]interface{}
	if err := json.Unmarshal(userJSON, &userInterface); err != nil {
		return err
	}

	if userDB.Exists("user:"+user.Email).Val() == 0 {
		if err := userDB.HMSet("user:"+user.Email, userInterface).Err(); err != nil {
			return err
		}
	} else {
		return fiber.NewError(fiber.StatusConflict, "User already exists")
	}

	return c.Status(fiber.StatusCreated).Send([]byte("User created successfully!"))
}

func Login(c *fiber.Ctx) error {
	userDB := database.CreateClient(0)

	user := new(schemas.User)

	userEmail := c.Get("email")
	userMasterPassword := c.Get("master_password")

	if userDB.Exists("user:"+userEmail).Val() == 0 {
		return fiber.NewError(fiber.StatusNotFound, "User not found")
	}

	userInterface := userDB.HGetAll("user:" + userEmail).Val()
	userJSON, err := json.Marshal(userInterface)
	if err != nil {
		return err
	}

	if err := json.Unmarshal(userJSON, &user); err != nil {
		return err
	}

	if user.MasterPassword != userMasterPassword {
		return fiber.NewError(fiber.StatusUnauthorized, "Invalid master password")
	}

	return c.Status(fiber.StatusOK).Send([]byte("User logged in successfully!"))
}

func GetUser(c *fiber.Ctx) error {
	userDB := database.CreateClient(0)

	userEmail := c.Get("email")

	userInterface := userDB.HGetAll("user:" + userEmail).Val()

	userJSON, err := json.Marshal(userInterface)
	if err != nil {
		return err
	}

	return c.Status(fiber.StatusOK).Send(userJSON)
}

func UpdateUser(c *fiber.Ctx) error {
	return nil
}

func DeleteUser(c *fiber.Ctx) error {
	return nil
}
