package schemas

type User struct {
	FirstName      string `json:"first_name"`
	LastName       string `json:"last_name"`
	Email          string `json:"email"`
	MasterPassword string `json:"master_password"`
}
