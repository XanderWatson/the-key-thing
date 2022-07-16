package schemas

type User struct {
	FirstName      string `json:"first_name" form:"first_name"`
	LastName       string `json:"last_name" form:"last_name"`
	Email          string `json:"email" form:"email"`
	MasterPassword string `json:"master_password" form:"master_password"`
}
