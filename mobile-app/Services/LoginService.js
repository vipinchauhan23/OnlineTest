loginService=  {
    userLogin(data) {
        return response = fetch('http://192.168.1.124:1337/login', {
            method: 'post',
            header: {
                'Accept': 'application.json',
                'Content-Type': 'application/json'
                // 'Authorization': 'Bearer ' + this.state.clientToken,
            },
            body: JSON.stringify(data)
        }).then((response) => response.json())     
    }
}
module.exports = loginService;