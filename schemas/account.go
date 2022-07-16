package schemas

type Account struct {
	Service  string `json:"service"`
	Login    string `json:"login"`
	Password string `json:"password"`
}
