/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
    AppRegistry,
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    Navigator,
} from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';
import Login from './Components/Login';
import Tests from './Components/Tests';
import CurrentTest from './Components/CurrentTest';
import Finish from './Components/FinishTest'
import styles from './Stylesheet/nav';

class OnlineTest extends Component {
    renderScene(route, navigator) {
        var globalNavigatorProps = { navigator }
        switch (route.routeName) {

            case "Login":
                return (

                    <Login {...globalNavigatorProps} />
                )

            case "Tests":
                return (

                    <Tests {...globalNavigatorProps} />
                )

            case "CurrentTest":
                return (

                    <CurrentTest {...globalNavigatorProps} />
                )
            case "FinishTest":
                return (

                    <Finish {...globalNavigatorProps} {...route.passProps} />
                )
        }
    }
    render() {
        return (
            <Navigator
                initialRoute={{ routeName: "Login" }}
                renderScene={this.renderScene}
                navigationBar={
                    <Navigator.NavigationBar
                        style={styles.navBar}
                        routeMapper={NavigationBarRouteMapper} />
                }

                />
        );
    }
}
const NavigationBarRouteMapper = {
    LeftButton(route, navigator, index, navState) {
        switch (route.routeName) {
            case 'Login':
                return (
                    <TouchableOpacity
                        style={styles.navBarLeftButton}
                        >
                    </TouchableOpacity>
                )
            default:
                return (
                    <TouchableOpacity
                        style={styles.navBarLeftButton}
                        onPress={() => { navigator.pop(); } }>
                        <Text style={[styles.navBarText]}>
                            back
                        </Text>
                    </TouchableOpacity>
                )
        }
    },

    RightButton(route, navigator, index, navState) {
        return (
            <TouchableOpacity
                style={styles.navBarRightButton}>
            </TouchableOpacity>
        )
    },

    Title(route, navigator, index, navState) {
        return (
            <Text style={[styles.navBarText, styles.navBarTitleText]}>
                {route.routeName}
            </Text>
        )
    }
}
AppRegistry.registerComponent('OnlineTestApp', () => OnlineTest);
