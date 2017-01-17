questionService = {
    questionSet(data) {
        return response = fetch('http://192.168.1.124:1337/questionSets/' + data.userid, {
            method: 'get',
            headers: {
                'Authorization': 'Bearer ' + data.clientToken
            }
        }).then((response) => response.json())
    },
    getQuestions(data) {
        return response = fetch('http://192.168.1.124:1337/getQuestionsbyUser/', {
            method: 'post',
            headers: {
                 'Accept': 'application.json',
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + data.clientToken
            },
             body: JSON.stringify(data)
        }).then((response) =>
            response.json()
            );
    },
    saveAns(data) {
        return response = fetch('http://192.168.1.124:1337/saveAnswer', {
            method: 'post',
            headers: {
                'Accept': 'application.json',
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + data.clientToken,
            },
            body: JSON.stringify(data)
        }).then((response) => response.json())
    },
    testTimeOut(data) {
        return response = fetch('http://192.168.1.124:1337/onlineTestTimeOut', {
            method: 'post',
            headers: {
                'Accept': 'application.json',
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + data.clientToken,
            },
            body: JSON.stringify(data)
        }).then((response) => response.json())
    },
    getTestResult(data) {
        return response = fetch('http://192.168.1.124:1337/testResult/' + data.testUserId, {
            method: 'get',
            headers: {
                'Authorization': 'Bearer ' + data.clientToken
            }
        }).then((response) =>
            response.json()
            );
    },
    handleError(error) {
        console.error('An error occurred', error);
        return Promise.reject(error.message || error);
    }
}
module.exports = questionService;
//fetch('http://192.168.1.124:1337/questionSets/'+data.userid