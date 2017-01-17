import React, { Component } from 'react'
var TimerMixin = require('react-timer-mixin');
var reactMixin = require('react-mixin');

import {
    Dimensions,
    StyleSheet,
    ScrollView,
    View,
    AsyncStorage,
    Image,
    Text,
    Navigator
} from 'react-native'
import questionService from '../Services/QuestionService';
import styles from '../Stylesheet/Style';
class Countdown extends Component {
    constructor(props) {
        super(props);

        this.state = {
            targetDate: new Date().toString(),
            time: {
                total: 0,
                days: 0,
                hours: 0,
                minutes: 0,
                seconds: 0
            }
        }
    }
    navigate(routeName) {
        // debugger;
        this.props.navigator.push({
            name: routeName
        });
    }
    redirect(routeName, id) {
        this.props.navigator.push({
            routeName: routeName,
            passProps: {
                testUserId: id,
            }
        });
    }

    componentWillMount() {
        this._loadInitialState().done();
    }
    componentDidMount() {
        this.timer = TimerMixin.setInterval(() => {

            this.refresh();
        }, 1000);
    }
    async _loadInitialState() {
        try {
            var date = new Date();
            var uservalue = await AsyncStorage.getItem('user');
            var userdata = JSON.parse(uservalue);
            this.state.clientToken = userdata.token;
            var value = await AsyncStorage.getItem('QuestionSetDetails');
            var questionSetDetails = JSON.parse(value);
            this.state.onlineTestUserId = questionSetDetails.online_test_user_id;
            this.setState({ totalTime: questionSetDetails.total_time });
            var targetDate = new Date(date.setMinutes(date.getMinutes() + this.state.totalTime))
            this.setState({ targetDate: targetDate });
        } catch (error) {
            console.log("error:" + error.message);
        }
    }
    componentWillUnmount() {
        TimerMixin.clearTimeout(this.timer);
    }

    refresh() {
        var t = Date.parse(this.state.targetDate) - Date.parse(new Date());
        var seconds = Math.floor((t / 1000) % 60);
        var minutes = Math.floor((t / 1000 / 60) % 60);
        var hours = Math.floor((t / (1000 * 60 * 60)) % 24);
        var days = Math.floor(t / (1000 * 60 * 60 * 24));
        var time = {
            'total': t,
            'days': days,
            'hours': hours,
            'minutes': minutes,
            'seconds': seconds
        };
        this.setState({ targetDate: this.state.targetDate, time: time });
        if (this.state.time.total == 0) {
            TimerMixin.clearTimeout(this.timer);
            questionService.testTimeOut(this.state).then((responseData) => {
                if (responseData.id) {
                    this.finishTest(responseData.id);
                    //  this.redirect('FinishTest');
                }
            });
        }
    }
    finishTest(id) {
        this.redirect('FinishTest', id);
    }

    render() {
        return (
            <View style={styles.container}>
                <View style={styles.contentrow} >
                    <Text>Time Remaining {this.state.time.hours}</Text>
                    <Text>: {this.state.time.minutes}</Text>
                    <Text>: {this.state.time.seconds}</Text></View>
            </View>
        )
    }
}

reactMixin(Countdown.prototype, TimerMixin);

module.exports = Countdown;