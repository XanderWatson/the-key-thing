package routes

import (
	"encoding/json"
	"strconv"

	"github.com/XanderWatson/the-key-thing/database"
	"github.com/XanderWatson/the-key-thing/schemas"
	"github.com/gofiber/fiber/v2"
)

func AddAccount(c *fiber.Ctx) error {
	accountsDB := database.CreateClient(1)

	account := new(schemas.Account)
	if err := c.BodyParser(account); err != nil {
		return err
	}

	accountJSON, err := json.Marshal(account)
	if err != nil {
		return err
	}

	userEmail := c.Get("email")
	if err := accountsDB.LPush("user:"+userEmail+":accounts", accountJSON).Err(); err != nil {
		return err
	}

	return c.Status(fiber.StatusCreated).Send([]byte("Account details added successfully!"))
}

func GetAccounts(c *fiber.Ctx) error {
	accountsDB := database.CreateClient(1)

	userEmail := c.Get("email")
	accounts, err := json.Marshal(accountsDB.LRange("user:"+userEmail+":accounts", 0, -1).Val())
	if err != nil {
		return err
	}

	return c.Status(fiber.StatusOK).Send(accounts)
}

func UpdateAccount(c *fiber.Ctx) error {
	accountsDB := database.CreateClient(1)

	userEmail := c.Get("email")
	idx, err := strconv.Atoi(c.Get("index"))
	if err != nil {
		return err
	}

	account := new(schemas.Account)
	if err := c.BodyParser(account); err != nil {
		return err
	}

	accountJSON, err := json.Marshal(account)
	if err != nil {
		return err
	}

	if err := accountsDB.LSet("user:"+userEmail+":accounts", int64(idx), accountJSON).Err(); err != nil {
		return err
	}

	return c.Status(fiber.StatusOK).Send([]byte("Account details updated successfully!"))
}

func DeleteAccount(c *fiber.Ctx) error {
	accountsDB := database.CreateClient(1)

	userEmail := c.Get("email")
	idx, err := strconv.Atoi(c.Get("index"))
	if err != nil {
		return err
	}

	accountJSON, err := accountsDB.LIndex("user:"+userEmail+":accounts", int64(idx)).Result()
	if err != nil {
		return err
	}

	if err := accountsDB.LRem("user:"+userEmail+":accounts", 1, accountJSON).Err(); err != nil {
		return err
	}

	return c.Status(fiber.StatusOK).Send([]byte("Account deleted successfully!"))
}
