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


loading =
    "loading"


type alias Model =
    Payload


type alias Payload =
    { humidity : Maybe Int
    , temperature : Maybe Int
    , heatIndex : Maybe Float
    }


init : ( Model, Cmd Msg )
init =
    ( Payload Nothing Nothing Nothing, Cmd.none )



-- UPDATE


type Msg
    = OnMessage Payload


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnMessage payload ->
            ( payload, Cmd.none )



-- SUBSCRIPTIONS


port onMessage : (Payload -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    onMessage OnMessage



-- VIEW


view : Model -> Html Msg
view model =
    let
        ( humidityClass, humidity ) =
            case model.humidity of
                Just humidity ->
                    ( if (40 <= humidity) && (humidity <= 55) then
                        "ok"
                      else
                        "bad"
                    , (toString humidity) ++ "%"
                    )

                Nothing ->
                    ( "loading", loading )

        temperature =
            case model.temperature of
                Just temperature ->
                    (toString temperature) ++ "°C"

                Nothing ->
                    loading

        heatIndex =
            case model.heatIndex of
                Just heatIndex ->
                    (toString heatIndex) ++ "°C"

                Nothing ->
                    loading
    in
        div []
            [ h1 [] [ text "Elm and MQTT" ]
            , dl []
                [ dt [ class humidityClass ] [ text "humidity" ]
                , dd [ class humidityClass ] [ text humidity ]
                , dt [] [ text "temperature" ]
                , dd [] [ text temperature ]
                , dt [] [ text "heatIndex" ]
                , dd [] [ text heatIndex ]
                ]
            ]
