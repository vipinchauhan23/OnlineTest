import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    TextInput,
    TouchableHighlight,
    AsyncStorage,
    View,
    ToastAndroid,
    Navigator
} from 'react-native';

import { Button, Subheader, COLOR } from 'react-native-material-design';
import styles from '../Stylesheet/Style';
import loginService from '../Services/LoginService';
class Login extends Component {
    constructor(props) {
        super(props);
        this.state = {
            username: "v@v",
            password: "qu",
            error: ''
        }
    }
    navigate(routeName) {
        // debugger;
        this.props.navigator.push({
            name: routeName
        });
    }

    redirect(routeName) {
        this.props.navigator.push({
            routeName: routeName
        });
    }

    storedUserdata(userValue) {
        try {
            AsyncStorage.setItem('user', JSON.stringify(userValue));
        }
        catch (error) {
            console.log("error:" + JSON.stringify(error));
        }
    }

    async _onLogin() {
        try {
            if (this.state.username === "" || this.state.password === "") {
                this.setState({ error: "email or pwd blank" })
                return false;
            }
            loginService.userLogin(this.state)
                .then((responseData) => {
                    if (responseData.user.user_id) {
                        this.storedUserdata(responseData);
                        this.redirect('Tests');
                       
                    }
                     else {
                    ToastAndroid.show('Test not alloted', ToastAndroid.LONG)
                }
                    // else {
                    //     this.setState.error({ error: responseData.err });
                    // }
                });
        } catch (error) {
            console.log("error" + JSON.stringify(error));
        }
    }
    render() {
           return (
            <View style={styles.maincontainer} >
                <Text style={styles.welcome}>
                    Welcome to Online Test!
                </Text>
                <Text style={styles.error}>
                    {this.state.error}
                </Text>
                <View style={styles.inputContainer}>
                    <TextInput  placeholder="Email/mobileNo"
                        onChangeText={(val) => this.setState({ username: this.state.username }) }
                        />
                </View>
                <View style={styles.inputContainer}>
                    <TextInput  placeholder="password" onChangeText={(val) => this.setState({ password: this.state.password }) }
                        secureTextEntry = {true}
                        />
                </View>

                <TouchableHighlight style={styles.login} onPress={this._onLogin.bind(this) }>
                    <Text style={styles.buttonText} >
                        Login
                    </Text>
                </TouchableHighlight>
            </View>
        );
    }
}

module.exports = Login;
