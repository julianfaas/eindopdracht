/**
 * Created with IntelliJ IDEA.
 * User: Joram
 * Date: 16/12/13
 * Time: 13:39
 * To change this template use File | Settings | File Templates.
 */
package be.devine.cp3.eindopdracht.mobile.view {

import be.devine.cp3.eindopdracht.model.AppModel;
import be.devine.cp3.eindopdracht.vo.ConversionVO;

import flash.display.BitmapData;

import starling.display.Button;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.HAlign;
import starling.utils.VAlign;

public class ConversionsList extends Sprite {

    [Embed(source="/../assets/custom/sheet.png")]
    protected static const ATLAS_IMAGE:Class;

    [Embed(source="/../assets/custom/sheet.xml",mimeType="application/octet-stream")]
    protected static const ATLAS_XML:Class;

    [Embed(source="/../assets/fonts/Fairview_Regular.otf",fontName="Fairview_Regular",mimeType="application/x-font",embedAsCFF="false")]
    protected static const FAIRVIEW_REGULAR:Class;

    [Embed(source="/../assets/fonts/Edmondsans-Regular.otf",fontName="Edmondsans-Regular",mimeType="application/x-font",embedAsCFF="false")]
    protected static const EDMONDSANS_REGULAR:Class;

    private var _createConversion:ConversionCreate;

    private var _btnMenu:Button;
    private var _btnNewConversion:Button;
    private var _mainMenu:MainScreen;
    private var _appModel:AppModel;

    private var _atlas:TextureAtlas;
    private var _title:TextField;
    private var conversionItem:Button;
    private var listContainer:Sprite;

    public function ConversionsList() {
        trace("[ConversionsList] Startup");
        _appModel = AppModel.getInstance();

        const atlasBitmapData:BitmapData = (new ATLAS_IMAGE()).bitmapData;
        _atlas = new TextureAtlas(Texture.fromBitmapData(atlasBitmapData, false), XML(new ATLAS_XML()));

        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
    }

    private function addedToStageHandler(event:Event):void {
        drawScreen();
    }

    private function drawScreen():void{
        _title = new TextField(300, 70, "Conversions", "FAIRVIEW_REGULAR", 60, 0xffffff);
        _title.x = 90;
        _title.hAlign = HAlign.CENTER;
        _title.vAlign = VAlign.TOP;
        addChild(_title);

        _btnMenu = new Button(_atlas.getTexture(("btnMenu")));
        _btnMenu.x = _btnMenu.y = 0;
        _btnMenu.width = 65;
        _btnMenu.height = 65;
        addChild( _btnMenu );
        _btnMenu.addEventListener(Event.TRIGGERED, menuTriggeredHandler);

        _btnNewConversion = new Button(_atlas.getTexture(("btnNewConversion")));
        _btnNewConversion.x = stage.width - _btnNewConversion.width;
        addChild( _btnNewConversion );
        _btnNewConversion.addEventListener(starling.events.Event.TRIGGERED, newTriggeredHandler);

         makeList();
    }

    private function makeList():void {
        listContainer = new Sprite();
        listContainer.x = 0;
        listContainer.y = _title.height;

        var items:uint = 0;
        var yPos:uint = 0;

        for each(var conversionVO:ConversionVO in _appModel.conversions) {
            trace("[ConversionsList]" + conversionVO.name, conversionVO.unit_1, conversionVO.unit_2, conversionVO.value_1, conversionVO.value_2);

            if(items % 2 == 0) {
                conversionItem = new Button(_atlas.getTexture("bgList1"));
            } else {
                conversionItem = new Button(_atlas.getTexture("bgList2"));
            }
            conversionItem.fontName = "Edmondsans-Regular";
            conversionItem.fontSize = 20;
            conversionItem.scaleWhenDown = 1;
            conversionItem.textHAlign = HAlign.LEFT;
            conversionItem.name = conversionVO.name;
            conversionItem.text = conversionVO.name + "\n" + conversionVO.unit_1 + " - " + conversionVO.unit_2;
            conversionItem.y = yPos;

            yPos += conversionItem.height;
            items++;
            conversionItem.addEventListener(Event.TRIGGERED, selectedConversionHandler);
            listContainer.addChild( conversionItem );
        }
        addChild( listContainer );
    }

    private function menuTriggeredHandler(event:Event):void {
        removeChild(_title);
        removeChild(_btnMenu);
        removeChild(_btnNewConversion);
        removeChild(listContainer);
        _mainMenu = new MainScreen();
        addChild(_mainMenu);
    }


    private function newTriggeredHandler(event:Event):void {
        removeChild(_title);
        removeChild(_btnMenu);
        removeChild(_btnNewConversion);
        removeChild(listContainer);
        _createConversion = new ConversionCreate();
        addChild(_createConversion);
    }

    private function selectedConversionHandler(event:Event):void {
        var current = event.currentTarget;
        trace(current.name);
    }
}
}
