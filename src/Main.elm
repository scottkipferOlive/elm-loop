port module Main exposing (main)

import Html.Attributes exposing (disabled)
import Json.Decode as Decode
import Json.Encode as Encode
import Platform exposing (worker)


type alias Model =
    {}


type Markdown
    = Markdown String


type ButtonStyle
    = Primary
    | Secondary
    | Text


type ButtonSize
    = Small
    | Large


type Button
    = Button String Bool ButtonStyle ButtonSize


newButton : String -> Bool -> ButtonStyle -> ButtonSize -> Button
newButton label disabled style size =
    Button label disabled style size


defaultButton : String -> Button
defaultButton label =
    Button label False Primary Small


buttonStyleToString : ButtonStyle -> String
buttonStyleToString style =
    case style of
        Primary ->
            "primary"

        Secondary ->
            "secondary"

        Text ->
            "text"


buttonSizeToString : ButtonSize -> String
buttonSizeToString size =
    case size of
        Small ->
            "small"

        Large ->
            "large"


buttonToJSON : Button -> Encode.Value
buttonToJSON (Button label disabled style size) =
    Encode.object
        [ ( "type", Encode.string "button" )
        , ( "label", Encode.string label )
        , ( "disabled", Encode.bool disabled )
        , ( "style", Encode.string <| buttonStyleToString style )
        , ( "size", Encode.string <| buttonSizeToString size )
        ]


markdownToJSON : Markdown -> Encode.Value
markdownToJSON (Markdown md) =
    Encode.object
        [ ( "type", Encode.string "markdown" )
        , ( "body", Encode.string md )
        ]


init : Int -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )


type Msg
    = OnSearch String
    | WhisperInteract Decode.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnSearch text ->
            ( model, newWhisper <| markdownToJSON (Markdown <| "hello " ++ text) )

        WhisperInteract _ ->
            ( model, Cmd.none )


main : Program Int Model Msg
main =
    worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }



-- PORTS


port onSearch : (String -> msg) -> Sub msg


port whisperInteract : (Decode.Value -> msg) -> Sub msg


port newWhisper : Encode.Value -> Cmd msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ onSearch OnSearch, whisperInteract WhisperInteract ]
