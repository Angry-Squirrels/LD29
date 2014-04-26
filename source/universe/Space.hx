package universe;

/**
 * ...
 * @author damrem
 */
class Space
{
	public var alt:UInt;
	public var long:Int;
	public var mask:UInt;
	public var neighbors:Array<Space>;
	
	public function new(?Alt:UInt, ?Long:Int, ?Mask:UInt) 
	{
		//trace(this, Alt, Long, Mask);
		alt = Alt;
		long = Long;
		mask = Mask;
		neighbors = new Array<Space>();
	}

	
	
	public function toString():String
	{
		return "[Space("+alt+", "+long+", "+mask+")]";
	}
	
}