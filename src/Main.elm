port module Main exposing (main)

import Html exposing (Html, h1, div, dl, dt, dd, text)
import Html.Attributes exposing (class)


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
    { current : Maybe Payload }


type alias Payload =
    { humidity : Int
    , temperature : Int
    , heatIndex : Float
    }


init : ( Model, Cmd Msg )
init =
    ( Model Nothing, Cmd.none )



-- UPDATE


type Msg
    = OnMessage Payload


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnMessage payload ->
            ( Model (Just payload), Cmd.none )



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
        , (viewCurrent model.current)
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
                        [ text (toString payload.humidity)
                        , text "%"
                        ]
                    , dt [] [ text "temperature" ]
                    , dd []
                        [ text (toString payload.temperature)
                        , text "°C"
                        ]
                    , dt [] [ text "heatIndex" ]
                    , dd []
                        [ text (toString payload.heatIndex)
                        , text "°C"
                        ]
                    ]

        Nothing ->
            div [] [ text loading ]
