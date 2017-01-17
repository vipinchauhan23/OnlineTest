import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    TextInput,
    TouchableHighlight,
    AsyncStorage,
    View,
    Navigator
} from 'react-native';

import styles from '../Stylesheet/Style';
import questionService from '../Services/QuestionService';
class Finish extends Component {
    constructor(props) {
        super(props);
        this.state = {};
        this.state.testUserId = props.testUserId;
    }
    navigate(routeName) {
        // debugger;
        this.props.navigator.push({
            name: routeName,
        });
    }

    redirect(routeName) {
        this.props.navigator.push({
            routeName: routeName
        });
    }
    componentDidMount() {
        this._loadInitialState().done();
    }
    async _loadInitialState() {
        try {
            var uservalue = await AsyncStorage.getItem('user');
            var userdata = JSON.parse(uservalue);
            this.state.clientToken = userdata.token;
            this.getTestResult();
        } catch (error) {
            console.log("error:" + error.message);
        }
    }

    getTestResult() {
        questionService.getTestResult(this.state).then((responseData) => {
            if (responseData.online_test_user_id) {
                this.setResult(responseData);
            }
        });
    }
    setResult(data) {
        this.setState({
            score: data.score,
            totalscore: data.totalscore
        });
    }

    newTest() {
        this.redirect('Login');
    }

    render() {
        return (
            <View style={styles.container} >
                <Text style={styles.welcome}>
                   Score: {this.state.score}
                </Text>
                <Text style={styles.instructions}>
                  TotalScore: {this.state.totalscore}
                </Text>
                <TouchableHighlight style={styles.button} onPress={() => this.newTest()}>
                    <Text style={styles.buttonText} >
                        Thanks
                    </Text>
                </TouchableHighlight>
            </View>
        )
    }
}

module.exports = Finish;
