port module Main exposing (main)

import Html exposing (Html, h1, div, dl, dt, dd, ul, li, text)
import Html.Attributes exposing (class)
import Html.Keyed as Keyed
import Html.Lazy exposing (lazy)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


loading : String
loading =
    "loading ..."


type alias Model =
    { current : Maybe Payload
    , humidityList : List SensorValue
    , temperatureList : List SensorValue
    }


type alias Payload =
    { humidity : Int
    , temperature : Int
    , heatIndex : Float
    , created : Int
    }


type alias SensorValue =
    { created : Int
    , value : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing [] [], Cmd.none )



-- UPDATE


type Msg
    = OnMessage Payload


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnMessage payload ->
            ( { model
                | current = (Just payload)
                , humidityList = (SensorValue payload.created payload.humidity) :: model.humidityList
                , temperatureList = (SensorValue payload.created payload.temperature) :: model.temperatureList
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


port onMessage : (Payload -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    onMessage OnMessage



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm and MQTT" ]
        , div [] [ (viewCurrent model.current) ]
        , div [] [ (lazy viewList model.humidityList) ]
        , div [] [ (lazy viewList model.temperatureList) ]
        ]


viewCurrent : Maybe Payload -> Html Msg
viewCurrent current =
    case current of
        Just payload ->
            let
                humidityClass =
                    if (40 <= payload.humidity) && (payload.humidity <= 55) then
                        "ok"
                    else
                        "bad"
            in
                dl []
                    [ dt [ class humidityClass ] [ text "humidity" ]
                    , dd [ class humidityClass ]
                        [ text ((toString payload.humidity) ++ "%") ]
                    , dt [] [ text "temperature" ]
                    , dd []
                        [ text ((toString payload.temperature) ++ "°C") ]
                    , dt [] [ text "heatIndex" ]
                    , dd []
                        [ text ((toString payload.heatIndex) ++ "°C") ]
                    ]

        Nothing ->
            div [] [ text loading ]


viewList : List SensorValue -> Html Msg
viewList list =
    if not (List.isEmpty list) then
        Keyed.node "ul" [] (List.map viewKeyedSensorValue list)
    else
        text loading


viewKeyedSensorValue : SensorValue -> ( String, Html msg )
viewKeyedSensorValue sensorValue =
    ( (toString sensorValue.created), lazy viewSensorValue sensorValue )


viewSensorValue : SensorValue -> Html msg
viewSensorValue sensorValue =
    li []
        [ text ("[" ++ (toString sensorValue.created) ++ "] " ++ (toString sensorValue.value)) ]
