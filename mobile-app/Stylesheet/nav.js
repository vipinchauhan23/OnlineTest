import { StyleSheet } from 'react-native';

export default StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'stretch',
        flexDirection: 'column',
        backgroundColor: 'transparent'
    },
    navBar: {
        justifyContent: 'center',
        alignItems: 'center',
        flex: .5,
        backgroundColor: '#009788',
    },
    navBarText: {
        color: 'white',
        fontSize: 16,
        marginVertical: 10

    },
    navBarTitleText: {
        // fontWeight: '500',
        marginVertical: 15,
        marginHorizontal: 75,
        //marginLeft:100,
        justifyContent: 'center',
        color: '#FFFFFF',
        fontWeight: 'bold',
        fontSize: 22
    },
    navBarLeftButton: {
        padding: 10,
    },
    navBarRightButton: {
        padding: 10,
        paddingTop: 5
    },
    scene: {
        flex: 1,
        paddingTop: 63,
    },
});
