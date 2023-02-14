import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'main.dart';
import 'MyModel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' hide log;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;



class MyCamera extends StatefulWidget {
  @override
  State<MyCamera> createState() => MyCameraState();
}

class MyCameraState extends State<MyCamera> {

  List<CameraDescription> _cameras = [];
  //Add external controllers here
  CameraController? controller;
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  //var plantNameList = ['Angel trumpet (Brugmansia suaveolens)', 'African sheepbush (Pentzia incana)', 'Alder (Alnus)', 'Black alder (Alnus glutinosa, Ilex verticillata)', 'Common alder (Alnus glutinosa)', 'False alder (Ilex verticillata)', 'Gray alder (Alnus incana)', 'Speckled alder (Alnus incana)', 'White alder (Alnus incana, Alnus rhombifolia, Ilex verticillata)', 'Almond (Prunus dulcis)', 'Aloe vera (Aloe vera)', 'Amaranth (Amaranthus)', 'Foxtail amaranth (Amaranthus caudatus)', 'Ambrosia', 'Tall ambrosia (Ambrosia trifida)', 'Amy root (Apocynum cannabinum)', 'Angel trumpet (Brugmansia suaveolens)', 'Apple (Malus domestica)', 'Apricot (Prunus armeniaca)', 'Arfaj (Rhanterium epapposum)', 'Arizona sycamore (Platanus wrighitii)', 'Arrowwood (Cornus florida)', 'Indian arrowwood (Cornus florida)', 'Ash (Fraxinus spp.)', 'Black ash (Acer negundo, Fraxinus nigra)', 'Blue ash (Fraxinus quadrangulata)', 'Cane ash (Fraxinus americana)', 'European ash (Fraxinus excelsior[1])', 'Green ash (Fraxinus pennsylvanica lanceolata)', 'Maple ash (Acer negundo)', 'Red ash (Fraxinus pennsylvanica lanceolata)', 'River ash (Fraxinus pennsylvanica)', 'Swamp ash (Fraxinus pennsylvanica)', 'White ash (Fraxinus americana)', 'Water ash (Acer negundo, Fraxinus pennsylvanica)', 'Azolla (Azolla)', 'Carolina azolla (Azolla caroliniana)', 'Bamboo (bamboosa ardinarifolia)', 'Banana (mainly Musa Ã— paradisica, but also other Musa species and hybrids)', 'Baobab (Adansonia)', 'Bay (Laurus spp. or Umbellularia spp.)', 'Bay laurel (Laurus nobilis (culinary))', 'California bay (Umbellularia californica)', 'Bean (Fabaceae, specifically Phaseolus spp.)', 'Bearberry (Ilex decidua)', 'Bear corn (Veratrum viride)', 'Beech (Fagus)', 'Bindweed', 'Blue bindweed (Solanum dulcamara)', 'Bird s nest (Daucus carota)', 'Bird s nest plant (Daucus carota)', 'Bird of paradise (Strelitzia reginae)', 'Birch (Betula spp.)', 'Black birch (Betula lenta, Betula nigra)', 'Bolean birch (Betula papyrifera)', 'Canoe birch (Betula papyrifera)', 'Cherry birch (Betula lenta)', 'European weeping birch (Betula pendula)', 'European white birch (Betula pendula)', 'Gray birch (Betula alleghaniensis)', 'Mahogany birch (Betula lenta)', 'Paper birch (Betula papyrifera)', 'Red birch (Betula nigra)', 'River birch (Betula nigra, Betula lenta)', 'Silver birch (Betula papyrifera)', 'Spice birch (Betula lenta)', 'Sweet birch (Betula lenta)', 'Water birch (Betula nigra)', 'Weeping birch (Betula pendula)', 'White birch (Betula papyrifera, Betula pendula)', 'Yellow birch (Betula alleghaniensis)', 'Bittercress (Barbarea vulgaris, Cardamine bulbosa, Cardamine hirsuta)', 'Hairy bittercress (Cardamine hirsuta)', 'Bittersweet (Solanum dulcamara)', 'Trailing bittersweet (Solanum dulcamara)', 'Bitterweed (Any plant in the genus Ambrosia, especially Ambrosia artemisiifolia, Artemisia trifida, Helenium amarum)', 'Blackberry (Rubus spp., Rubus pensilvanicus, Rubus occidentalis)', 'Hispid swamp blackberry (Rubus hispidus)', 'Pennsylvania blackberry (Rubus pensilvanicus)', 'Running swamp blackberry (Rubus hispidus)', 'Black cap (Rubus occidentalis)', 'Black-eyed Susan (Rudbeckia hirta, Rudbeckia fulgida)', 'Blackhaw (Viburnum prunifolium)', 'Blackiehead (Rudbeckia hirta)', 'Black-weed (Ambrosia artemisiifolia)', 'Blueberry (Vaccinium (Cyanococcus) spp.)', 'Bluebell (Hyacinthoides non-scripta)', 'Blue-of-the-heavens (Allium caeruleum)', 'Bow-wood (Maclura pomifera)', 'Box (Buxus)', 'False box (Cornus florida)', 'Boxelder (Acer negundo)', 'Boxwood (Buxus, Cornus florida)', 'False boxwood (Cornus florida)', 'Brier', 'Sand brier (Solanum carolinense)', 'Brittlebush (Encelia farinosa)', 'Broadleaf (Plantago major)', 'Brown Betty (Rudbeckia hirta)', 'Brown-eyed susan (Rudbeckia hirta, Rudbeckia triloba)', 'Buckeye (California buckeye) (Aesculus californica)', 'Buckeye (Aesculus spp.)', 'Buffalo weed (Ambrosia trifida)', 'Bugle (Ajuga reptans)', 'Butterfly flower (Asclepias syriaca)', 'Butterfly weed (Asclepias tuberosa)', 'Columbine (Aquilegia vulgaris)', 'Cabbage (Brassica oleracea)', 'Clumpfoot cabbage (Symplocarpus foetidus)', 'Meadow cabbage (Symplocarpus foetidus)', 'Skunk cabbage (Symplocarpus foetidus, Lysichiton spp.)', 'Swamp cabbage (Symplocarpus foetidus)', 'California bay (Umbellularia californica)', 'California buckeye (Aesculus californica)', 'California sycamore (Platanus racemosa)', 'California walnut (Juglans californica)', 'Canada root (Asclepias tuberosa)', 'Cancer jalap (Phytolacca americana)', 'Carrot (Daucus carota)', 'Wild carrot (Daucus carota)', 'Carrot weed (Ambrosia artemisiifolia)', 'Cart track plant (Plantago major)', 'Catalina ironwood (Lyonothamnus floribundus ssp. floribundus)', 'Cedar (Cedrus spp.)', 'Blue Atlas cedar (Cedrus atlantica)', 'Deodar cedar (Cedrus deodara)', 'Chalk milkwort (Polygala calcarea)', 'Charlock (Sinapis arvensis)', 'Cherry (Prunus spp.)', 'Black cherry (Prunus serotina)', 'Cabinet cherry (Prunus serotina)', 'Rum cherry (Prunus serotina)', 'Whiskey cherry (Prunus serotina)', 'Wild cherry (Prunus avium, Prunus serotina)', 'Wild black cherry (Prunus serotina)', 'Chestnut (Castanea spp.)', 'Chigger flower (Asclepias tuberosa)', 'Chrysanthemum (Dendranthema grandiflora [vi], Chrysanthemum morifolium)', '(True) cinnamon (Cinnamomum verum)', 'Clove (Syzygium aromaticum)', 'Clover (Trifolium spp.)', 'Coakum (Phytolacca americana)', 'Coconut (Cocos nucifera)', 'Coffee plant (Coffea spp.)', 'Colic weed (Corydalis flavula)', 'Collard (Symplocarpus foetidus)', 'Columbine (Aquilegia vulgaris)', 'Colwort', 'Hare s colwort (Sonchus oleraceus)', 'Comfrey (Symphytum spp.)', 'Coneflower', 'Brilliant coneflower (Rudbeckia fulgida)', 'Cutleaf coneflower (Rudbeckia laciniata)', 'Eastern coneflower (Rudbeckia fulgida)', 'Green-headed Coneflower (Rudbeckia laciniata)', 'Orange coneflower (Rudbeckia fulgida)', 'Tall coneflower (Rudbeckia laciniata)', 'Thin-leaved Coneflower (Rudbeckia triloba)', 'Three-leaved Coneflower (Rudbeckia triloba)', 'Cornel', 'Blueberry cornel (Cornus amomum)', 'Silky cornel (Cornus amomum)', 'White cornel (Cornus florida)', 'Cornelian tree (Cornus florida)', 'Corydalis (Corydalis spp.)', 'Fern-leaf Corydalis (Corydalis chelidoniifolia)', 'Golden corydalis (Corydalis aurea)', 'Pale corydalis (Corydalis flavula, Corydalis sempervirens)', 'Pink corydalis (Corydalis sempervirens)', 'Yellow corydalis (Corydalis lutea, Corydalis flavula)', 'Cotton plant (Gossypium)', 'Creeping yellowcress (Rorippa sylvestris)', 'Cress ((several genera))', 'American cress (Barbarea verna)', 'Bank cress (Barbarea verna)', 'Belle Isle cress (Barbarea verna)', 'Bermuda cress (Barbarea verna)', 'Bulbous cress (Cardamine bulbosa)', 'Lamb s cress (Cardamine hirsuta)', 'Land cress (Barbarea verna, Cardamine hirsuta)', 'Scurvy cress (Barbarea verna)', 'Spring cress (Cardamine bulbosa)', 'Upland cress (Barbarea verna)', 'Crowfoot (Cardamine concatenata)', 'Crow s nest (Daucus carota)', 'Crow s toes (Cardamine concatenata)', 'Cucumber (Cucumis sativus)', 'Flowering Dogwood (Cornus florida)', 'Daisy', 'Brown daisy (Rudbeckia hirta)', 'Common daisy, daisy (Bellis perennis)', 'Gloriosa daisy (Rudbeckia hirta)', 'Poorland daisy (Rudbeckia hirta)', 'Yellow daisy (Rudbeckia hirta)', 'Yellow ox-eye daisy (Rudbeckia hirta)', 'Deadnettle (Lamium spp.)', 'Henbit deadnettle (Lamium amplexicaule)', 'Red deadnettle (Lamium purpureum)', 'Spotted deadnettle (Lamium maculatum)', 'Desert Rose (Adenium obesum)', 'Devil s bite (Veratrum viride)', 'Devil s darning needle (Clematis virginiana)', 'Devil s nose (Clematis virginiana)', 'Devil s plague (Daucus carota)', 'Dewberry', 'Bristly dewberry (Rubus hispidus)', 'Swamp dewberry (Rubus hispidus)', 'Dindle (Sonchus arvensis)', 'Dogwood (Cornus spp.)', 'American dogwood (Cornus florida)', 'Florida dogwood (Cornus florida)', 'Flowering dogwood (Cornus florida)', 'Japanese flowering dogwood (Cornus kousa)', 'Kousa dogwood (Cornus kousa)', 'Drumstick (Moringa oleifera)', 'Pacific dogwood (Cornus nuttallii)', 'Silky dogwood (Cornus amomum)', 'Swamp dogwood (Cornus amomum)', 'Duck retten (Veratrum viride)', 'Duscle (Solanum nigrum)', 'Durian (Durio zibethinus)', 'Durian kura kura (Durio testudinarius)', 'Durian munjit (Durio grandiflorus)', 'Durian pulu (Durio kutejensis)', 'Red durian (Durio dulcis)', 'Dye-leaves (Ilex glabra)', 'Easter orchid (Cattleya schroederae)', 'Easter orchid (Cattleya schroederae)', 'Earth gall (Veratrum viride)', 'Elderberry (Sambucus)', 'Elegant lupine (Lupinus elegans)', 'Elephant apple (Dillenia indica)', 'English bull s eye (Rudbeckia hirta)', 'Eucalyptus (Eucalyptus spp.)', 'Evergreen huckleberry (Vaccinium ovatum)', 'Extinguisher moss (Encalypta)', 'Eytelia (Amphipappus)', 'Fellenwort (Solanum dulcamara)', 'Fair-maid-of-France (Achillea ptarmica)', 'Fairymoss Azolla caroliniana', 'Fellenwort (Solanum dulcamara)', 'Felonwood (Solanum dulcamara)', 'Felonwort (Solanum dulcamara)', 'Fennel (Foeniculum vulgare)', 'Ferns', 'Boston fern or sword fern (Nephrolepis exaltata)', 'Christmas fern (Polystichum acrostichoides)', 'Coast polypody (Polypodium scouleri)', 'Kimberly queen fern (Nephrolepis obliterata)', 'Korean rock fern (Polystichum tsus-simense)', 'Mosquito fern (Azolla caroliniana)', 'Sword ferns (Polystichum spp.)', 'Water fern (Azolla caroliniana)', 'Western sword fern (Polystichum munitum)', 'Feverbush (Ilex verticillata)', 'Feverfew (Tanacetum parthenium)', 'Field forget-me-not (Myosotis arvensis)', 'Fig (Ficus spp.)', 'Common fig (Ficus carica)', 'Flax', 'European flax (Linum usitatissimum)', 'New Zealand flax (Phormium tenax, Phormium colensoi)', 'Fluxroot (Asclepias tuberosa)', 'Foxglove (Digitalis purpurea)', 'Fumewort', 'Yellow fumewort (Corydalis flavula)', 'Golden chain (Laburnum)', 'Gallberry (Ilex glabra)', 'Garget (Phytolacca americana)', 'Garlic', 'Golden garlic (Allium moly)', 'Wild garlic (Allium canadense)', 'Garlic mustard (Alliaria petiolata)', 'Garlic root (Alliaria petiolata)', 'Germander speedwell (Veronica chamaedrys)', 'Gilliflower', 'Dame s gilliflower (Hesperis matronalis)', 'Night scented gilliflower (Hesperis matronalis)', 'Queen s gilliflower (Hesperis matronalis)', 'Rogue s gilliflower (Hesperis matronalis)', 'Winter gilliflower (Hesperis matronalis)', 'Golden buttons (Tanacetum vulgare)', 'Golden chain (Laburnum)', 'Goldenglow (Rudbeckia laciniata)', 'Golden Jerusalem (Rudbeckia hirta)', 'Gordaldo (Achillea millefolium)', 'Goose tongue (Achillea ptarmica)', 'Grapefruit (Citrus Ã— paradisi)', 'Grapevine (Vitis)', 'Green berry nightshade (Solanum opacum)', 'Groundberry (Rubus hispidus)', 'Bristly groundberry (Rubus hispidus)', 'Gutweed (Sonchus arvensis)', 'Hellebore (Helleborus orientalis)', 'Haldi (Curcuma domestica)', 'Harlequin', 'Rock harlequin (Corydalis sempervirens)', 'Yellow harlequin (Corydalis flavula)', 'Hay fever weed (Ambrosia artemisiifolia, Artemisia trifida)', 'Healing blade (Plantago major)', 'Hedge plant (Maclura pomifera)', 'Hellebore (Helleborus)', 'American white hellebore (Veratrum viride)', 'Big hellebore (Veratrum viride)', 'Black hellebore (Veratrum nigrum)', 'European white hellebore (Veratrum album)', 'False hellebore (Veratrum album, Veratrum viride)', 'Swamp hellebore (Veratrum viride)', 'White hellebore (Veratrum album, Veratrum viride)', 'Hemp (Cannabis spp., specifically Cannabis sativa)', 'Hemp dogbane (Apocynum cannabinum)', 'Hen plant (Plantago major)', 'Herb barbara (Barbarea vulgaris)', 'Hogweed (Ambrosia artemisiifolia)', 'Holly (Ilex spp.)', 'Deciduous holly (Ilex decidua, Ilex verticillata)', 'European holly (Ilex aquifolium)', 'Inkberry holly (Ilex glabra)', 'Meadow holly (Ilex decidua)', 'Swamp holly (Ilex decidua)', 'Winterberry holly (Ilex verticillata)', 'Honesty (Lunaria annua)', 'Horse cane (Ambrosia trifida)', 'Hound s berry (Solanum nigrum)', 'Huckleberry (Vaccinium spp.)', 'Evergreen huckleberry (Vaccinium ovatum)', 'Trailing red huckleberry (Vaccinium parvifolium)', 'Houseleek (Sempervivum tectorum)', 'Hydrangea (Hydrangea macrophylla)', 'Ivy (Hedera)', 'Indian hemp (various genera)', 'Indian hemp (Apocynum cannabinum, Cannabis indica)', 'White Indian hemp (Asclepias incarnata)', 'Indian paintbrush (Castilleja, Castilleja mutis, Asclepias tuberosa)', 'Indian posy (Asclepias tuberosa)', 'Inkberry (Ilex glabra, Phytolacca americana)', 'Ironwood (Acacia estrophiolata)', 'Isle of Man cabbage (Coincya monensis)', 'Itchweed (Veratrum viride)', 'Ivy (Hedera spp.)', 'Jasmine (Jasminum officinale)', 'Jack-by-the-hedge (Alliaria petiolata)', 'Jack-in-the-bush (Alliaria petiolata)', 'Jasmine (Jasminum officinale)', 'Jewel orchid (Ludisia discolor)', 'Jointed rush (Juncus kraussii)', 'Jugflower (Adenanthos obovatus)', 'Juneberry (Amelanchier canadensis)', 'Juniper (Various species in the genus Juniperus)', 'Kudzu (Pueraria montana)', 'Keek (Rorippa sylvestris)', 'King fern (Ptisana salicina)', 'Kinnikinnik (Cornus amomum)', 'Kittentail (Veronica bullii)', 'Knotweed (Japanese) (Reynoutria japonica (syn. Fallopia japonica))', 'Kousa (Cornus kousa)', 'Kudzu (Pueraria montana)', 'Kumarahou (Pomaderris kumeraho)', 'Lavender (Lavandula angustifolia)', 'Laceflower (Daucus carota)', 'Lace fern (Asparagus setaceus)', 'Lady s mantle (Alchemilla mollis)', 'Lady s smock (Cardamine pratensis)', 'Lamb s foot (Plantago major)', 'Latanier palm (Phoenicophorium)', 'Laurel magnolia (Magnolia splendens)', 'Lavender (Lavandula)', 'Leek (Allium)', 'Lemon (Citrus Ã— limon)', 'Leopard lily (Lilium catesbaei)', 'Lily of the Nile (Agapanthus praecox)', 'Lettuce (Lactuca sativa)', 'Lily leek (Allium moly)', 'Lilac', 'Summer lilac (Hesperis matronalis)', 'Little sunflower (Helianthella)', 'Lone fleabane (Erigeron cavernensis)', 'Love-lies-bleeding (Amaranthus caudatus)', 'Love vine (Clematis virginiana)', 'Lupin (Lupinus)', 'Southern magnolia (Magnolia grandiflora)', 'Magnolia (Magnolia)', 'Bracken s Brown Beauty magnolia (Magnolia grandiflora)', 'Galaxy magnolia (Magnolia x)', 'Jane magnolia (Magnolia x)', 'Kay Parris magnolia (Magnolia grandiflora)', 'Little Gem magnolia (Magnolia grandiflora)', 'Moonglow magnolia (Magnolia virginiana)', 'Royal Star magnolia (Magnolia stellata)', 'Serendipity Ruby magnolia (Magnolia figo)', 'Southern magnolia (Magnolia grandiflora)', 'Stellar Ruby magnolia (Magnolia figo)', 'Sweetbay magnolia (Magnolia virginiana)', 'Waterlilly Star magnolia (Magnolia stellata)', 'Maize (Zea mays)', 'Mango (Mangifera indica)', 'Maple (Acer)', 'Ash-leaved maple (Acer negundo)', 'Black maple (Acer nigrum)', 'Creek maple (Acer saccharinum)', 'Cutleaf maple (Acer negundo)', 'Maple ash (Acer negundo)', 'Moose maple (Acer pensylvanicum)', 'Red river maple (Acer negundo)', 'River maple (Acer saccharinum)', 'Silver maple (Acer saccharinum)', 'Silverleaf maple (Acer saccharinum)', 'Soft maple (Acer saccharinum)', 'Striped maple (Acer pensylvanicum)', 'Sugar maple (Acer saccharum (main use), Acer barbatum, Acer leucoderme,)', 'Swamp maple (Acer saccharinum)', 'Water maple (Acer saccharinum)', 'White maple (Acer saccharinum)', 'Mesquite (Prosopis)', 'Honey mesquite (Prosopis glandulosa)', 'Screwbean mesquite (Prosopis pubescens)', 'Milfoil (Achillea millefolium)', 'Milkweed (Asclepias, Sonchus oleraceus)', 'Blunt-leaved Milkweed (Asclepias amplexicaulis)', 'Common milkweed (Asclepias syriaca)', 'Horsetail milkweed (Asclepias verticillata)', 'Orange milkweed (Asclepias tuberosa)', 'Swamp milkweed (Asclepias incarnata)', 'Rose milkweed (Asclepias incarnata)', 'Whorled milkweed (Asclepias verticillata)', 'Yellow milkweed (Asclepias tuberosa)', 'Milky tassel (Sonchus oleraceus)', 'Moosewood (Acer pensylvanicum)', 'Petty morel (Solanum nigrum)', 'Morel', 'Petty morel (Solanum nigrum)', 'Morelle verte (Solanum opacum)', 'Mosquito plant (Azolla caroliniana)', 'Mother-of-the-evening (Hesperis matronalis)', 'Mountain mahogany (Betula lenta)', 'Mulberry (Morus)', 'Red mulberry (Morus rubra)', 'White mulberry (Morus alba)', 'Native fuchsia (Epacris longiflora)', 'Native fuchsia (Epacris longiflora)', 'Necklace fern (Asplenium flabellifolium)', 'Neem (Azadirachta indica)', 'Nettle (Urtica dioica)', 'Bull nettle (Solanum carolinense)', 'Carolina horse nettle (Solanum carolinense)', 'Horse nettle (Solanum carolinense)', 'Night-blooming cactus (Hylocereus)', 'Nightshade', 'American nightshade (Phytolacca americana, Solanum americanum)', 'Bitter nightshade (Solanum dulcamara)', 'Black nightshade (Solanum nigrum, Solanum americanum)', 'Climbing nightshade (Solanum dulcamara)', 'Deadly nightshade (Atropa belladonna)', 'Garden nightshade (Solanum nigrum)', 'Trailing nightshade (Solanum dulcamara)', 'Trailing violet nightshade (Solanum dulcamara)', 'Woody nightshade (Solanum dulcamara)', 'Nodding wakerobin (Trillium cernuum)', 'Northern moonwort (Botrychium boreale)', 'Nosebleed (Achillea millefolium)', 'Sweet orange (Citrus Ã— sinensis)', 'Oak tree (Quercus)', 'Algerian Oak (Quercus canariensis)', 'Blue oak (Quercus douglasii)', 'Bur oak (Quercus macrocarpa)', 'California Black Oak Quercus kelloggii', 'Canyon Live Oak Quercus chrysolepis', 'Champion oak (Quercus rubra)', 'Coast live oak (Quercus agrifolia)', 'Cork oak (Quercus suber)', 'Dyer s oak (Quercus velutina)', 'Eastern black oak (Quercus velutina)', 'English oak (Quercus robur)', 'Island oak (Quercus tomentella)', 'Mirbeck s oak (Quercus canariensis)', 'Mossycup white oak (Quercus macrocarpa)', 'Northern red oak (Quercus rubra)', 'Pedunculate oak (Quercus robur)', 'Pin oak (Quercus palustris)', 'Red oak (Quercus rubra, Quercus coccinea)', 'Scarlet oak (Quercus coccinea)', 'Scrub oak (Quercus macrocarpa)', 'Sessile oak (Quercus petraea)', 'Spanish oak (Quercus coccinea, Quercus rubra)', 'Spotted oak (Quercus velutina)', 'Swamp oak (Quercus palustris, Quercus bicolor)', 'Swamp Spanish oak (Quercus palustris)', 'Swamp white oak (Quercus bicolor)', 'Valley oak (Quercus lobata)', 'White oak (Quercus alba)', 'Yellowbark oak (Quercus velutina)', 'Obedient Plant (Physostegia virginiana)', 'Olive (Olea europaea)', 'Onion (Allium)', 'Common onion (Allium cepa)', 'Giant onion (Allium giganteum)', 'Nodding onion (Allium cernuum)', 'Tree onion (Allium canadense)', 'Wild onion (Allium canadense)', 'Orange â€“', 'Osage orange (Maclura pomifera)', 'Sweet orange (Citrus Ã— sinensis)', 'Wild orange (Maclura pomifera)', 'Orange-root (Asclepias tuberosa)', 'Osage (Maclura pomifera)', 'Osier (Salix; (in North America) Cornus)', 'Red osier (Cornus amomum)', 'Golden poppy (Eschscholzia californica)', 'Parsley (Petroselinum crispum)', 'Parsnip (Pastinaca sativa, Daucus carota)', 'Pea (Pisum sativum)', 'Peach (Prunus persica)', 'Peanut (Arachis hypogaea)', 'Pear (Pyrus)', 'Pellitory', 'Bastard pellitory (Achillea ptarmica)', 'European pellitory (Achillea ptarmica)', 'Wild pellitory (Achillea ptarmica)', 'Penny hedge (Alliaria petiolata)', 'Pepper root (Cardamine concatenata)', 'Petty spurge (Euphorbia peplus)', 'Pigeon berry (Phytolacca americana)', 'Pine (Pinus)', 'Loblolly Pine (Pinus taeda)', 'Pineapple (Ananas comosus)', 'Pistachio (Pistacia vera)', 'Plane (European sycamore) (Platanus acerifolia)', 'Plantain', 'Broadleaf plantain (Plantago major)', 'Common plantain (Plantago major)', 'Dooryard plantain (Plantago major)', 'Greater plantain (Plantago major)', 'Roundleaf plantain (Plantago major)', 'Wayside plantain (Plantago major)', 'Pleurisy root (Asclepias tuberosa)', 'Poached egg plant (Limnanthes douglasii)', 'Pocan bush (Phytolacca americana)', 'Poison ivy (Toxicodendron radicans)', 'Poisonberry (Solanum dulcamara)', 'Poisonflower (Solanum dulcamara)', 'Poke (Phytolacca americana)', 'Indian poke (Veratrum viride)', 'Pokeroot (Phytolacca americana)', 'Pokeweed (Phytolacca americana)', 'Polkweed (Symplocarpus foetidus)', 'Polecat weed (Symplocarpus foetidus)', 'Poor Annie (Veratrum viride)', 'Poor man s mustard (Alliaria petiolata)', 'Poplar (Populus)', 'Poppy (Papaveraceae)', 'Possumhaw (Ilex decidua)', 'Potato (Solanum tuberosum)', 'Primrose (Primula vulgaris)', 'Queen Anne s lace (Daucus carota, Anthriscus sylvestris)', 'Quercitron (Quercus velutina)', 'Multiflora rose (Rosa multiflora)', 'Radical weed (Solanum carolinense)', 'Ragweed (Ambrosia)', 'Common ragweed (Ambrosia artemisiifolia)', 'Giant ragweed (Ambrosia trifida)', 'Great ragweed (Ambrosia trifida)', 'Ragwort (Senecio)', 'Common ragwort (Senecio jacobaea)', 'Hoary ragwort (Senecio erucifolius)', 'Marsh ragwort (Senecio aquaticus)', 'Oxford ragwort (Senecio squalidus)', 'Silver ragwort (Senecio cineraria)', 'Rantipole (Daucus carota)', 'Rapeseed (Brassica napus)', 'Raspberry (Rubus (Idaeobatus) spp.)', 'Black raspberry (Rubus occidentalis)', 'Purple raspberry (Rubus occidentalis)', 'Redbrush (Cornus amomum)', 'Redbud (Cercis spp.)', 'Eastern redbud (Cercis canadensis)', 'Western redbud (Cercis occidentalis)', 'Judas-tree (Cercis siliquastrum)', 'Red ink plant (Phytolacca americana)', 'Redweed (Phytolacca americana)', 'Rheumatism root (Apocynum cannabinum)', 'Rhubarb (Rheum rhabarbarum)', 'Ribwort (Plantago major)', 'Rice', 'Asian rice (Oryza sativa)', 'African rice (Oryza glaberrima)', 'Roadweed (Plantago major)', 'Rocket ((several genera))', 'Dame s rocket (Hesperis matronalis)', 'Sweet rocket (Hesperis matronalis)', 'Winter rocket (Barbarea vulgaris)', 'Yellow rocket (Barbarea vulgaris)', 'Rocketcress (Barbarea vulgaris)', 'Rose (Rosa)', 'Baby rose (Rosa multiflora)', 'Dwarf wild rose (Rosa virginiana)', 'Low rose (Rosa virginiana)', 'Multiflora rose (Rosa multiflora)', 'Prairie rose (Rosa virginiana)', 'Rambler rose (Rosa multiflora)', 'Wild rose (Rosa virginiana)', 'Rosemary (Rosmarinus officinalis)', 'Rye (Secale cereale)', 'Snowdrop (Galanthus)', 'Saffron crocus (Crocus sativus)', 'Sanguinary (Achillea millefolium)', 'Saskatoon (Amelanchier alnifolia)', 'Sauce-alone (Alliaria petiolata)', 'Scarlet berry (Solanum dulcamara)', 'Scoke (Phytolacca americana)', 'Scotch cap (Rubus occidentalis)', 'Scrambled eggs (Corydalis aurea)', 'Scurvy grass (Barbarea verna)', 'Serviceberry (Amelanchier)', 'Common serviceberry (Amelanchier arborea)', 'Downy serviceberry (Amelanchier arborea)', 'Shadblow serviceberry (Amelanchier canadensis)', 'Shadblow (Amelanchier canadensis)', 'Shadbush (Amelanchier canadensis)', 'Shrubby mayweed (Oncosiphon suffruticosum)', 'Silkweed (Asclepias syriaca)', 'Swamp silkweed (Asclepias incarnata)', 'Virginia silkweed (Asclepias syriaca)', 'Skunkweed (Symplocarpus foetidus)', 'Snakeberry (Solanum dulcamara)', 'Snowdrop (Galanthus)', 'Sorrel (Oxalis)', 'Redwood sorrel (Oxalis oregana)', 'Speedwell', 'Corn speedwell (Veronica arvensis)', 'Wall speedwell (Veronica arvensis)', 'Spikenard (Nardostachys jatamansi)', 'Spoolwood (Betula papyrifera)', 'Squaw bush (Cornus amomum)', 'Stammerwort (Ambrosia artemisiifolia)', 'Star-of-Persia (Allium cristophii)', 'Stickweed (Ambrosia artemisiifolia)', 'Strawberry (Fragaria Ã— ananassa)', 'Strawberry tree (Arbutus unedo)', 'Strawberry tree Marina (Madrone Arbutus Marina)', 'Sugarcane (Saccharum)', 'Swallow-wort', 'Orange swallow-wort (Asclepias tuberosa)', 'Silky swallow-wort (Asclepias syriaca)', 'Sneezeweed (Achillea ptarmica)', 'Sneezewort (Achillea ptarmica)', 'Sunflower (Helianthus annuus)', 'Sugarplum (Amelanchier canadensis)', 'Soldier s woundwort (Achillea millefolium)', 'Stag bush (Viburnum prunifolium)', 'Swallow-wort', 'Orange swallow-wort (Asclepias tuberosa)', 'Silky swallow-wort (Asclepias syriaca)', 'Sweet potato (Ipomoea batatas)', 'Sweet potato vine (Ipomoea batatas)', 'Swinies (Sonchus oleraceus)', 'Sycamore (Platanus spp.)', 'Sycamore (California) (Platanus racemosa)', 'Sycamore (Arizona) (Platanus wrighitii)', 'Sycamore (American) (Platanus occidentalis)', 'Sundari (Bangladesh) (Heritiera fomes)', 'Gewa (Bangladesh) (Excoecaria agallocha)', 'Tobacco plant (Nicotiana glauca)', 'Tansy', 'Common tansy (Tanacetum vulgare)', 'White tansy (Achillea ptarmica)', 'Wild tansy (Ambrosia artemisiifolia)', 'Tea (Camellia sinensis)', 'Appalachian tea (Ilex glabra)', 'Thimbleberry (Rubus occidentalis)', 'Thimbleweed (Rudbeckia laciniata)', 'Thousand-leaf (Achillea millefolium)', 'Thousand-seal (Achillea millefolium)', 'Tassel weed (Ambrosia artemisiifolia)', 'Thistle ((Several genera))', 'Annual sow thistle (Sonchus oleraceus)', 'California thistle (Cirsium arvense)', 'Canada thistle (Cirsium arvense)', 'Corn thistle (Cirsium arvense)', 'Corn sow thistle (Sonchus arvensis)', 'Creeping thistle (Cirsium arvense)', 'Cursed thistle (Cirsium arvense)', 'Field sow thistle (Sonchus arvensis)', 'Green thistle (Cirsium arvense)', 'Hard thistle (Cirsium arvense)', 'Hare s thistle (Sonchus oleraceus)', 'Milk thistle (Sonchus oleraceus)', 'Nodding thistle (Carduus nutans L.)', 'Perennial thistle (Cirsium arvense)', 'Prickly thistle (Cirsium arvense)', 'Sharp-fringed sow Thistle (Sonchus asper)', 'Small-flowered Thistle (Cirsium arvense)', 'Spiny sow thistle (Sonchus asper)', 'Spiny-leaved sow Thistle (Sonchus asper)', 'Swine thistle (Sonchus arvensis)', 'Tree sow thistle (Sonchus arvensis)', 'Way thistle (Cirsium arvense)', 'Thyme (Thymus, specifically Thymus vulgaris)', 'Tickleweed (Veratrum viride)', 'Tobacco plant (Nicotiana)', 'Tomato (Solanum lycopersicum)', 'Toothwort (Cardamine concatenata)', 'Cutleaf toothwort (Cardamine concatenata)', 'Purple-flowered Toothwort (Cardamine concatenata)', 'Touch-me-not (Impatiens capensis, Impatiens pallida, Mimosa pudica, Cardamine hirsuta)', 'Traveller s joy (Clematis virginiana)', 'Tread-softly (Solanum carolinense)', 'Tree tobacco (Nicotiana glauca)', 'Trillium (Trillium spp.)', 'Western trillium (Trillium ovatum)', 'Western wake robin (Trillium ovatum)', 'White trillium (Trillium grandiflorum)', 'Tuber-root (Asclepias tuberosa)', 'Tulip (Tulipa)', 'Tulsi (Ocimum santalum)', 'Umbrella palm (Hedyscepe canterburyana)', 'Umbrella papyrus (Cyperus alternifolius)', 'Voodoo lily (Dracunculus vulgaris)', 'Vanilla orchid (Vanilla)', 'Varnish tree (Koelreuteria paniculata)', 'Velvet bean (Mucuna pruriens)', 'Viburnum (Viburnum)', 'Blackhaw viburnum (Viburnum prunifolium)', 'Leatherleaf viburnum (Viburnum rhytidophyllum)', 'Violet ((several genera))', 'Viola species', 'African violet (Streptocarpus sect. Saintpaulia species)', 'Damask violet (Hesperis matronalis)', 'Dame s violet (Hesperis matronalis)', 'Dog s-tooth-violet or dogtooth violet (Erythronium dens-canis)', 'Violet bloom (Solanum dulcamara)', 'Viper s grass (Scorzonera hispanica)', 'Virgin s bower (Clematis virginiana)', 'Virginia virgin s bower (Clematis virginiana)', 'Voodoo lily (Dracunculus vulgaris)', 'Woolly morning glory (Argyreia nervosa)', 'Walnut (Juglans sp.)', 'Wattle (Acacia)', 'Mount Connor wattle (Acacia ammobia)', 'Waybread (Plantago major)', 'Weed (Marijuana) â€” Cannabis Sativa, Cannabis Indica, Cannabis Ruderalis', 'Western redbud (Cercis occidentalis)', 'Wheat (Triticum spp.)', 'White man s foot (Plantago major)', 'White-root (Asclepias tuberosa)', 'Wild cotton (Apocynum cannabinum, Asclepias syriaca)', 'Wild honeysuckle (Lambertia)', 'Prickly honeysuckle (Lambertia echinata)', 'Heath-leaved honeysuckle (Lambertia ericifolia)', 'Fairall s honeysuckle (Lambertia fairallii)', 'Mountain devil (Lambertia formosa)', 'Honey flower (Lambertia formosa)', 'Holly-leaved honeysuckle (Lambertia ilicifolia)', 'Chittick (Lambertia inermis)', 'Many-flowered honeysuckle (Lambertia multiflora)', 'Round-leaf honeysuckle (Lambertia orbifolia)', 'Green honeysuckle (Lambertia rariflora)', 'Wild hops (Clematis virginiana)', 'Willow (Salix)', 'Coyote willow (Salix exigua)', 'Goodding willow (Salix gooddingii)', 'Red willow (Cornus amomum)', 'Rose willow (Cornus amomum)', 'Windroot (Asclepias tuberosa)', 'Wineberry (Rubus phoenicolasius)', 'Winterberry (Ilex verticillata)', 'American winterberry (Ilex verticillata)', 'Evergreen winterberry (Ilex glabra)', 'Virginia winterberry (Ilex verticillata)', 'Wintercress (Barbarea vulgaris)', 'Early wintercress (Barbarea verna)', 'Woodbine (Clematis virginiana)', 'Woolly morning glory (Argyreia nervosa)', 'Wormwood', 'Roman wormwood (Ambrosia artemisiifolia, Corydalis sempervirens)', 'Wound rocket (Barbarea vulgaris)', 'Yellow coneflower (Echinacea paradoxa)', 'Yarrow (Achillea)', 'Common yarrow (Achillea millefolium)', 'Fernleaf yarrow (Achillea filipendulina)', 'Sneezewort yarrow (Achillea ptarmica)', 'Woolly yarrow (Achillea tomentosa)', 'Yellow fieldcress (Rorippa sylvestris)', 'Yellowwood (Cladrastis lutea, Maclura pomifera)', 'Yellow coneflower (Echinacea paradoxa)', 'Yam (Dioscorea)', 'Yunnan camellia (Camellia yunnanensis)', 'Zebrawood (Brachystegia spiciformis)', 'Zebrawood (Brachystegia spiciformis)'];
  VideoPlayerController? videoController;

  File? _imageFile;
  File? _videoFile;

  // To store the retrieved files
  List<File> allFileList = [];

  File _image = File('images/bouncy_balls.gif');

  refreshAlreadyCapturedImages() async {
    log("Hey, it's me!: refreshAlreadyCapturedImages");
    // Get the directory
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    allFileList.clear();

    List<Map<int, dynamic>> fileNames = [];

    // Searching for all the image and video files using
    // their default format, and storing them
    fileList.forEach((file) {
      if (file.path.contains('.jpg') || file.path.contains('.mp4')) {
        //log("refreshAlreadyCapturedImages - file is jpg or mp4");
        //log("refreshAlreadyCapturedImages - file.path: ");
        //log(file.path);
        allFileList.add(File(file.path));

        //log("before file path split: ");
        String name = file.path.split('/').last.split('.').first;
        String cleanName = name.replaceAll("img", "");
        /*
        log("file name: ");
        log(cleanName);
        log("0: int.parse(cleanName): ");
        log(int.parse(cleanName).toString());
        log("1: file.path.split('/').last : ");
        log(file.path.split('/').last);
        */
        fileNames.add({0: int.parse(cleanName), 1: file.path.split('/').last});
      }
    });

    // Retrieving the recent file
    if (fileNames.isNotEmpty) {
      final recentFile =
      fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
      String recentFileName = recentFile[1];
      // Checking whether it is an image or a video file
      if (recentFileName.contains('.mp4')) {
        _videoFile = File('${directory.path}/$recentFileName');
        _startVideoPlayer();
      } else {
        _imageFile = File('${directory.path}/$recentFileName');
      }

      setState(() {});
    }
  }

  Future<void> _startVideoPlayer() async {
    log("Hey, it's me!: _startVideoPlayer");
    if (_videoFile != null) {
      videoController = VideoPlayerController.file(_videoFile!);
      await videoController!.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
        setState(() {});
      });
      await videoController!.setLooping(true);
      await videoController!.play();
    }
  }

  Future<XFile?> takePicture() async {
    log("Hey, it's me!: takePicture");
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  void takPicture() async {
    log("Hey, it's me!: takPicture");
    XFile? rawImage = await takePicture();
    log("rawImage type is :");
    log(rawImage.runtimeType.toString());

    log("rawImage!.path:");
    log(rawImage!.path);
    File imageFile = File(rawImage!.path);
    log("imageFile type is :");
    log(imageFile.runtimeType.toString());


    int currentUnix = DateTime.now().millisecondsSinceEpoch;
    log("currentUnix:");
    log(currentUnix.toString());

    final directory = await getApplicationDocumentsDirectory();
    //final dirGallery = await
    log("directory path:");
    log(directory.path);
    String fileFormat = imageFile.path.split('.').last;
    log("fileFormat:");
    log(fileFormat);

    log("image save path:");
    log('${directory.path}/$currentUnix.$fileFormat');
    await imageFile.copy(
      '${directory.path}/$currentUnix.$fileFormat',
    );

    refreshAlreadyCapturedImages();

    log("files in app directory:");
    final dir = Directory('/data/user/0/com.example.mspr_dev_ia_app_arosaje/app_flutter');
    final List<FileSystemEntity> entities = await dir.list().toList();
    entities.forEach(print);

    _image = imageFile;
    //predictImagePicker();

  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    log("Hey, it's me!: onNewCameraSelected");
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void initState() {
    log("Hey, it's me!: initState");
    super.initState();
    //onNewCameraSelected(_cameras[0]);
    getPermissionStatus();


  }

  Future<void> _getAvailableCameras() async {
    log("Hey, it's me!: _getAvailableCameras");
    try {
      final cameras = await availableCameras();
      setState(() {
        _cameras = cameras;
        log("Cameras list updated:");
        log(_cameras.toString());
        log(_cameras[0].toString());
        log(_cameras[1].toString());
      });
    } catch (e) {
      print("_getAvailableCameras $e");
    }
  }

  getPermissionStatus() async {
    log("Hey, it's me!: getPermissionStatus");
    await Permission.camera.request();
    var status = await Permission.camera.status;
    if (status.isGranted) {
      log('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      //List available cameras on the device
      _getAvailableCameras();
      // Set and initialize the new camera
      onNewCameraSelected(_cameras[0]);
      refreshAlreadyCapturedImages();
    } else {
      log('Camera Permission: DENIED');
    }
  }

  @override
  void dispose() {
    log("Hey, it's me!: dispose");
    controller?.dispose();
    videoController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("Hey, it's me!: didChangeAppLifecycleState");
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Spacer(),

          Row(
            children: [
              Spacer(),
              _isCameraInitialized
                  ? Container(
                  child: AspectRatio(
                      aspectRatio: 1.0 / (300/500),
                      child:Stack(
                        alignment: Alignment.center,
                        children: [
                          _isCameraPermissionGranted
                              ? controller!.buildPreview()
                              : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(),
                              Text(
                                'Permission denied',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  getPermissionStatus();
                                },
                                child: Text('Give permission'),
                              ),
                            ],
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: Colors.white, width: 2),
                                    image: _imageFile != null
                                        ? DecorationImage(
                                      image: FileImage(_imageFile!),
                                      fit: BoxFit.cover,
                                    )
                                        : null,
                                  ),
                                  child: videoController != null && videoController!.value.isInitialized
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: AspectRatio(
                                      aspectRatio: videoController!.value.aspectRatio,
                                      child: VideoPlayer(videoController!),
                                    ),
                                  )
                                      : Container(),
                                )
                                ,Spacer(flex:11),
                                ClipOval(
                                  child: Material(
                                    color: Colors.blue, // Button color
                                    child: InkWell(
                                      splashColor: Colors.red, // Splash color
                                      onTap: takPicture,
                                      child: SizedBox(width: 56, height: 56, child: Icon(Icons.camera)),
                                    ),
                                  ),
                                ),
                                Spacer(flex:1),
                              ]
                          )
                        ],
                      )),
                  width: 300,height: 500
              )
                  :Container(color: Colors.black,width: 300,height: 300,),
              Spacer()
            ],),

          Container(
            height: 40,
          ),

          Spacer(flex: 3,)
        ],
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: ,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
      //Add non body content here
    );
  }
}