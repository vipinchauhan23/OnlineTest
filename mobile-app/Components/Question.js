
import React, { Component } from 'react';
import {
  Text, StyleSheet,
  TouchableOpacity,
  AsyncStorage,
  ListView,
  View } from 'react-native';



class Question extends Component {
  constructor(props) {
    super(props);
    this.onLoad = this.onLoad.bind(this);
    this.onProgress = this.onProgress.bind(this);
  }
 

  onLoad(data) {
    this.setState({ duration: data.duration });
  }

  onProgress(data) {
    this.setState({ currentTime: data.currentTime });
  }

  getCurrentTimePercentage() {
    if (this.state.currentTime > 0) {
      return parseFloat(this.state.currentTime) / parseFloat(this.state.duration);
    } else {
      return 0;
    }
  }

  renderRateControl(rate) {
    const isSelected = (this.state.rate == rate);

    return (
      <TouchableOpacity onPress={() => { this.setState({ rate: rate }) } }>
        <Text style={[styles.controlOption, { fontWeight: isSelected ? "bold" : "normal" }]}>
          {rate}x
        </Text>
      </TouchableOpacity>
    )
  }

  renderResizeModeControl(resizeMode) {
    const isSelected = (this.state.resizeMode == resizeMode);

    return (
      <TouchableOpacity onPress={() => { this.setState({ resizeMode: resizeMode }) } }>
        <Text style={[styles.controlOption, { fontWeight: isSelected ? "bold" : "normal" }]}>
          {resizeMode}
        </Text>
      </TouchableOpacity>
    )
  }

  renderVolumeControl(volume) {
    const isSelected = (this.state.volume == volume);

    return (
      <TouchableOpacity onPress={() => { this.setState({ volume: volume }) } }>
        <Text style={[styles.controlOption, { fontWeight: isSelected ? "bold" : "normal" }]}>
          {volume * 100}%
        </Text>
      </TouchableOpacity>
    )
  }

  render() {
    const flexCompleted = this.getCurrentTimePercentage() * 100;
    const flexRemaining = (1 - this.getCurrentTimePercentage()) * 100;
    return (
      <View style={styles.container} >
        <Text  style={styles.buttonText}>
          question {this.props.questionNumber}
        </Text>
        <View style={styles.rowpattern}>

         

          <View style={styles.controls}>
            <View style={styles.generalControls}>
              <View style={styles.rateControl}>
                {this.renderRateControl(0.25) }
                {this.renderRateControl(0.5) }
                {this.renderRateControl(1.0) }
                {this.renderRateControl(1.5) }
                {this.renderRateControl(2.0) }
              </View>

              <View style={styles.volumeControl}>
                {this.renderVolumeControl(0.5) }
                {this.renderVolumeControl(1) }
                {this.renderVolumeControl(1.5) }
              </View>

              <View style={styles.resizeModeControl}>
                {this.renderResizeModeControl('cover') }
                {this.renderResizeModeControl('contain') }
                {this.renderResizeModeControl('stretch') }
              </View>
            </View>

            <View style={styles.trackingControls}>
              <View style={styles.progress}>
                <View style={[styles.innerProgressCompleted, { flex: flexCompleted }]} />
                <View style={[styles.innerProgressRemaining, { flex: flexRemaining }]} />
              </View>
            </View>
          </View>

        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'black',
  },
  fullScreen: {
    position: 'absolute',
    top: 0,
    left: 0,
    bottom: 0,
    right: 0,
  },
  controls: {
    backgroundColor: "transparent",
    borderRadius: 5,
    position: 'absolute',
    bottom: 20,
    left: 20,
    right: 20,
  },
  progress: {
    flex: 1,
    flexDirection: 'row',
    borderRadius: 3,
    overflow: 'hidden',
  },
  innerProgressCompleted: {
    height: 20,
    backgroundColor: '#cccccc',
  },
  innerProgressRemaining: {
    height: 20,
    backgroundColor: '#2C2C2C',
  },
  generalControls: {
    flex: 1,
    flexDirection: 'row',
    borderRadius: 4,
    overflow: 'hidden',
    paddingBottom: 10,
  },
  rateControl: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'center',
  },
  volumeControl: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'center',
  },
  resizeModeControl: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  controlOption: {
    alignSelf: 'center',
    fontSize: 11,
    color: "white",
    paddingLeft: 2,
    paddingRight: 2,
    lineHeight: 12,
  },
});
module.exports = Question;