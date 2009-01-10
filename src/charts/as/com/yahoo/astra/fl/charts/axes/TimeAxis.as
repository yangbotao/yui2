﻿package com.yahoo.astra.fl.charts.axes
{
	import com.yahoo.astra.fl.charts.series.ISeries;
	import com.yahoo.astra.fl.charts.CartesianChart;
	import com.yahoo.astra.utils.DateUtil;
	import com.yahoo.astra.utils.TimeUnit;
	import com.yahoo.astra.utils.TextUtil;
	import fl.core.UIComponent;
	import flash.text.TextFormat;

	/**
	 * An axis type representing a date and time range from minimum to maximum
	 * with major and minor divisions.
	 * 
	 * @author Josh Tynjala
	 */
	public class TimeAxis extends BaseAxis implements IAxis, IStackingAxis
	{
		
	//--------------------------------------
	//  Static Properties
	//--------------------------------------
	
		
		/**
		 * @private
		 */
		private static const TIME_UNITS:Array = [TimeUnit.MILLISECONDS, TimeUnit.SECONDS, TimeUnit.MINUTES, TimeUnit.HOURS, TimeUnit.DAY, TimeUnit.MONTH, TimeUnit.YEAR];
			
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function TimeAxis()
		{
			super();
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
	
		protected var positionMultiplier:Number = 0;
	
		/**
		 * @private
		 * Storage for the minimum value.
		 */
		private var _minimum:Date;
		
		/**
		 * @private
		 * Indicates whether the minimum bound is user-defined or generated by the axis.
		 */
		private var _minimumSetByUser:Boolean = false;
		
		/**
		 * The minimum value displayed on the axis.
		 */
		public function get minimum():Date
		{
			return this._minimum;
		}
		
		/**
		 * @private
		 */
		public function set minimum(value:Date):void
		{
			this._minimum = value;
			this._minimumSetByUser = value != null;
		}
	
		/**
		 * @private
		 * Storage for the maximum value.
		 */
		private var _maximum:Date;
		
		/**
		 * @private
		 * Indicates whether the maximum bound is user-defined or generated by the axis.
		 */
		private var _maximumSetByUser:Boolean = false;
		
		/**
		 * The maximum value displayed on the axis.
		 */
		public function get maximum():Date
		{
			return this._maximum;
		}
		
		/**
		 * @private
		 */
		public function set maximum(value:Date):void
		{
			this._maximum = value;
			this._maximumSetByUser = value != null;
		}
	
	//-- Units
	
		/**
		 * @private
		 * Storage for the major unit.
		 */
		private var _majorUnit:int = 1;
		
		/**
		 * @private
		 * Indicates whether the major unit is user-defined or generated by the axis.
		 */
		private var _majorUnitSetByUser:Boolean = false;
		
		/**
		 * The major unit at which new lines are drawn.
		 */
		public function get majorUnit():Number
		{
			return this._majorUnit;
		}
		
		/**
		 * @private
		 */
		public function set majorUnit(value:Number):void
		{
			this._majorUnit = value;
			this._majorUnitSetByUser = !isNaN(value);
		}
	
		/**
		 * @private
		 * Storage for the majorTimeUnit property.
		 */
		private var _majorTimeUnit:String = TimeUnit.MONTH;
		
		/**
		 * @private
		 * Indicates whether the major time unit is user-defined or generated by the axis.
		 */
		private var _majorTimeUnitSetByUser:Boolean = false;
		
		/**
		 * Combined with majorUnit, determines the amount of time between major ticks and labels.
		 * 
		 * @see com.yahoo.astra.fl.charts.TimeUnit;
		 */
		public function get majorTimeUnit():String
		{
			return this._majorTimeUnit;
		}
		
		/**
		 * @private
		 */
		public function set majorTimeUnit(value:String):void
		{
			this._majorTimeUnit = value;
			this._majorTimeUnitSetByUser = value != null;
		}
	
		/**
		 * @private
		 * Storage for the minor unit.
		 */
		private var _minorUnit:int = 1;
		
		/**
		 * @private
		 * Indicates whether the minor unit is user-defined or generated by the axis.
		 */
		private var _minorUnitSetByUser:Boolean = false;
		
		/**
		 * The minor unit at which new lines are drawn.
		 */
		public function get minorUnit():Number
		{
			return this._minorUnit;
		}
		
		/**
		 * @private
		 */
		public function set minorUnit(value:Number):void
		{
			this._minorUnit = value;
			this._minorUnitSetByUser = !isNaN(value);
		}
	
		/**
		 * @private
		 * Storage for the minorTimeUnit property.
		 */
		private var _minorTimeUnit:String = TimeUnit.MONTH;
		
		/**
		 * @private
		 * Indicates whether the minor time unit is user-defined or generated by the axis.
		 */
		private var _minorTimeUnitSetByUser:Boolean = false;
		
		/**
		 * Combined with minorUnit, determines the amount of time between minor ticks.
		 * 
		 * @see com.yahoo.astra.fl.charts.TimeUnit;
		 */
		public function get minorTimeUnit():String
		{
			return this._minorTimeUnit;
		}
		
		/**
		 * @private
		 */
		public function set minorTimeUnit(value:String):void
		{
			this._minorTimeUnit = value;
			this._minorTimeUnitSetByUser = value != null;
		}
		
		/**
		 * @private
		 * Storage for the stackingEnabled property.
		 */
		private var _stackingEnabled:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function get stackingEnabled():Boolean
		{
			return this._stackingEnabled;
		}
		
		/**
		 * @private
		 */
		public function set stackingEnabled(value:Boolean):void
		{
			this._stackingEnabled = value;
		}
	
		/**
		 * @private
		 * Storage for the snapToUnits property.
		 */
		private var _snapToUnits:Boolean = true;
		
		/**
		 * If true, the labels, ticks, gridlines, and other objects will snap to
		 * the nearest major or minor unit. If false, their position will be based
		 * on the minimum value.
		 */
		public function get snapToUnits():Boolean
		{
			return this._snapToUnits;
		}
		
		/**
		 * @private
		 */
		public function set snapToUnits(value:Boolean):void
		{
			this._snapToUnits = value;
		}
		
		/**
		 * @private
		 */
		private var _dataMinimum:Date;
		
		/**
		 * @private
		 */
		private var _dataMaximum:Date;
		
		/**
		 * @private
		 */
		private var _numLabels:Number;
		
		/**
		 * @private
		 */		
		private var _numLabelsSetByUser:Boolean = false;

		/**
		 * @inheritDoc
		 */
		public function get numLabels():Number
		{
			return _numLabels;
		}
		
		/**
		 * @private (setter)
		 */
		public function set numLabels(value:Number):void
		{
			if(_numLabelsSetByUser) return;
			_numLabels = value;
			_numLabelsSetByUser = true;
			_majorUnitSetByUser = false;
			_minorUnitSetByUser = false;			
		}
		 
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * @inheritDoc
		 */
		public function stack(top:Object, ...rest:Array):Object
		{
			var value:Number = this.valueToNumber(top);
			var restCount:int = rest.length;
			for(var i:int = 0; i < restCount; i++)
			{
				value += this.valueToNumber(rest[i]);
			}
			return value;
		}
	
		/**
		 * @inheritDoc
		 */
		public function updateScale():void
		{			
			this.resetScale();
			this.calculatePositionMultiplier();
			
			this.renderer.ticks = this.createAxisData(this.majorUnit, this.majorTimeUnit);
			this.renderer.minorTicks = this.createAxisData(this.minorUnit, this.minorTimeUnit, false);
		}
		
		/**
		 * @inheritDoc
		 */
		public function valueToLocal(value:Object):Number
		{
			var numericValue:Number = this.valueToNumber(value);
			
			var position:Number = (numericValue - this.minimum.valueOf()) * this.positionMultiplier;
			if(this.reverse)
			{
				position = this.renderer.length - position;
			}
				
			return position;
		}
	
		/**
		 * @inheritDoc
		 */
		override public function valueToLabel(value:Object):String
		{
			var text:String = value.toString();
			if(this.labelFunction != null)
			{
				var numericValue:Number = this.valueToNumber(value);
				text = this.labelFunction(new Date(numericValue), this.majorTimeUnit);
			}			
			if(text == null)
			{
				text = "";
			}
			return text;
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
		
		/**
		 * @private
		 * Converts one of the accepted values to a Number that can be
		 * used for position calculation.
		 */
		protected function valueToNumber(value:Object):Number
		{
			var convertedValue:Number = 0;
			if(value is Date)
			{
				convertedValue = (value as Date).valueOf();
			}
			else if(!(value is Number))
			{
				convertedValue = new Date(value.toString()).valueOf();
			}
			else
			{
				convertedValue = value as Number;
			}
			return convertedValue;
		}
		
		/**
		 * @private
		 * Calculates the best scale.
		 */
		protected function resetScale():void
		{
			if(!this._minimumSetByUser)
			{
				this._minimum = new Date(this._dataMinimum.valueOf());
			}
				
			if(!this._maximumSetByUser)
			{
				this._maximum = new Date(this._dataMaximum.valueOf());
			}
			
			this.checkMinLessThanMax();
			this.calculateMajorUnit();
			this.calculateMinorUnit();
		}
		
		/**
		 * @private
		 * Generates AxisData objects for use by the axis renderer.
		 */
		protected function createAxisData(unit:Number, timeUnit:String, isMajorUnit:Boolean = true):Array
		{
			if(unit <= 0)
			{
				return [];
			}
			
			var data:Array = [];
			var displayedMaximum:Boolean = false;
			var displayedMinimum:Boolean = false;
			var date:Date = new Date(this.minimum.valueOf());
			var itemCount:int = 0;
			while(date.valueOf() <= this.maximum.valueOf())
			{
				date = new Date(this.minimum.valueOf());
				if(itemCount > 0)
				{
					var unitValue:Number = itemCount * unit;
					date = this.updateDate(date, timeUnit, unitValue, this.snapToUnits);
				}
				
				//stop at the maximum value.
				if(date.valueOf() > this.maximum.valueOf())
				{
					break;
					//if(isMajorUnit) break;
					//date = new Date(this.maximum.valueOf());
				}
				//because Flash UIComponents round the position to the nearest pixel, we need to do the same.
				var position:Number = Math.round(this.valueToLocal(date));
				var label:String = this.valueToLabel(date);
				var axisData:AxisData = new AxisData(position, date, label);
				data.push(axisData);
				itemCount++;
				
				if(date.valueOf() == this.maximum.valueOf())
				{
					break;
				}
			}
			
			return data;
		}

		/**
		 * @inheritDoc
		 */
		public function getMaxLabel():String
		{
			var maxLength:Number = 0;
			var currentLength:Number;
			var maxString:String  = "x";
			
			var newDate:Date = new Date(this._minimum);
			var maxDate:Date = new Date(this._maximum);
			while(newDate.valueOf() < maxDate.valueOf())
			{
				currentLength = (newDate.toString()).length;
				if(currentLength > maxLength)
				{
					maxLength = currentLength;
					maxString = newDate.toString();
				}
				newDate = this.updateDate(newDate, this.majorTimeUnit, 1, this.snapToUnits);
			}
			return maxString as String;	
		}			

	//--------------------------------------
	//  Private Methods
	//--------------------------------------
		
		/**
		 * @private
		 */
		private function updateDate(date:Date, timeUnit:String, unitValue:Number, snapToUnits:Boolean):Date
		{
			switch(timeUnit)
			{
				case TimeUnit.YEAR:
					date.fullYear += unitValue;
					if(snapToUnits)
					{
						date.month = 0;
						date.date = 1;
						date.hours = 0;
						date.minutes = 0;
						date.seconds = 0;
						date.milliseconds = 0;
					}
					break;
				case TimeUnit.MONTH:
					date.month += unitValue;
					if(snapToUnits)
					{
						date.date = 1;
						date.hours = 0;
						date.minutes = 0;
						date.seconds = 0;
						date.milliseconds = 0;
					}
					break;
				case TimeUnit.DAY:
					date.date += unitValue;
					if(snapToUnits)
					{
						date.hours = 0;
						date.minutes = 0;
						date.seconds = 0;
						date.milliseconds = 0;
					}
					break;
				case TimeUnit.HOURS:
					date.hours += unitValue;
					if(snapToUnits)
					{
						date.minutes = 0;
						date.seconds = 0;
						date.milliseconds = 0;
					}
					break;
				case TimeUnit.MINUTES:
					date.minutes += unitValue;
					if(snapToUnits)
					{
						date.seconds = 0;
						date.milliseconds = 0;
					}
					break;
				case TimeUnit.SECONDS:
					date.seconds += unitValue;
					if(snapToUnits)
					{
						date.milliseconds = 0;
					}
					break;
				case TimeUnit.MILLISECONDS:
					date.milliseconds += unitValue;
					break;
			}
			return date;
		}
		
		/**
		 * @private
		 * Swaps the minimum and maximum values, if needed.
		 */
		private function checkMinLessThanMax():void
		{
			if(this._minimum.valueOf() > this._maximum.valueOf())
			{
				var temp:Date = this._minimum;
				this._minimum = this._maximum;
				this._maximum = temp;
				
				//be sure to swap these flags too!
				var temp2:Boolean = this._minimumSetByUser;
				this._minimumSetByUser = this._maximumSetByUser;
				this._maximumSetByUser = temp2;
			}
		}
		
		/**
		 * @private
		 * Determines the best major unit.
		 */
		private function calculateMajorUnit():void
		{
			if(!this._majorTimeUnitSetByUser)
			{
				//ballpark it
				var dayCount:Number = DateUtil.countDays(this.minimum, this.maximum);
				var yearCount:Number = DateUtil.getDateDifferenceByTimeUnit(this.minimum, this.maximum, TimeUnit.YEAR);
				var monthCount:Number = DateUtil.getDateDifferenceByTimeUnit(this.minimum, this.maximum, TimeUnit.MONTH);
				var hourCount:Number = dayCount * 24;
				var minuteCount:Number = hourCount * 60;
				var secondCount:Number = minuteCount * 60;
				
				if(yearCount >= 1) this._majorTimeUnit = TimeUnit.YEAR;
				else if(monthCount >= 1) this._majorTimeUnit = TimeUnit.MONTH;
				else if(dayCount >= 1) this._majorTimeUnit = TimeUnit.DAY;
				else if(hourCount >= 1) this._majorTimeUnit = TimeUnit.HOURS;
				else if(minuteCount >= 1) this.majorTimeUnit = TimeUnit.MINUTES;
				else if(secondCount >= 1) this.majorTimeUnit = TimeUnit.SECONDS; 
				else this.majorTimeUnit = TimeUnit.MILLISECONDS;
			}
			
			if(this._majorUnitSetByUser)
			{
				return;
			}
			
			this.calculateMaximumAndMinimum();
		
			var approxLabelDistance:Number;
			//Check to see if this axis is horizontal. Since the width of labels will be variable, we will need to apply a different alogrithm to determine the majorUnit.
			if((this.chart as CartesianChart).horizontalAxis == this)
			{
				//extract the approximate width of the labels by getting the textWidth of the maximum date when rendered by the label function with the textFormat of the renderer.
				approxLabelDistance = this.maxLabelWidth;
			
			}
			else
			{
				approxLabelDistance = this.maxLabelHeight;	
			}
			var labelPadding:Number = 2; 
			approxLabelDistance += (labelPadding*2);

			var dateDifference:Number = Math.round(DateUtil.getDateDifferenceByTimeUnit(this.minimum, this.maximum, this.majorTimeUnit));
			var tempMajorUnit:Number = 0; 

			var maxLabels:Number = Math.floor((this.renderer.length - labelPadding)/approxLabelDistance);
			
			//If set by user, use specified number of labels unless its too many
			if(this._numLabelsSetByUser)
			{
				maxLabels = Math.min(maxLabels, this.numLabels);
			}
			
			tempMajorUnit = dateDifference/maxLabels;
			tempMajorUnit = Math.ceil(tempMajorUnit);
			tempMajorUnit = Math.min(tempMajorUnit, Math.round(dateDifference/2));
			
			this._majorUnit = tempMajorUnit;
			
			if(dateDifference%tempMajorUnit != 0)
			{
				var len:Number = Math.min(tempMajorUnit, ((dateDifference/2)-tempMajorUnit));
				for(var i:int = 0;i < len; i++)
				{
					tempMajorUnit++;
					if(dateDifference%tempMajorUnit == 0)
					{
						this._majorUnit = tempMajorUnit;
						break;
					}
				}		
			}
		}
		
		/**
		 * @private
		 * Determines the best minor unit.
		 */
		private function calculateMinorUnit():void
		{
			if(!this._minorTimeUnitSetByUser)
			{
				//if the numeric part of the major unit is 1, we want to move
				//the time part of the minor unit to a interval lower than the major.
				//...unless the user has set the minor unit. this is a weird case
				//that shouldn't happen, but it might.
				//in that case, we go with the standard behavior where major unit
				//and minor unit are the same.
				if(!this._minorUnitSetByUser && this._majorUnit == 1)
				{
					var index:int = TIME_UNITS.indexOf(this._majorTimeUnit);
					if(index > 0) this._minorTimeUnit = TIME_UNITS[index - 1];
				}
				else this._minorTimeUnit = this._majorTimeUnit;
			}
			
			if(this._minorUnitSetByUser)
			{
				return;
			}
			
			if(this.majorTimeUnit == this.minorTimeUnit && this._majorUnit != 1)
			{
				if(this._majorUnit % 2 == 0)
				{
					this._minorUnit = this._majorUnit / 2;
				}
				else if(this._majorUnit % 3 == 0)
				{
					this._minorUnit = this._majorUnit / 3;
				}
				else this._minorUnit = 0;
			}
			else
			{
				//in this case, we know that the time portion of the minor
				//unit is a smaller interval than the major unit.
				switch(this._minorTimeUnit)
				{
					case TimeUnit.MONTH:
						this._minorUnit = 6;
						break;
						
					//no perfect half-way point for number of days in a month
					//so use the default of zero
					/*case TimeUnit.DAY:
						break;*/
						
					case TimeUnit.HOURS:
						this._minorUnit = 12;
						break;
						
					case TimeUnit.MINUTES:
						this._minorUnit = 30;
						break;
						
					case TimeUnit.SECONDS:
						this._minorUnit = 30;
						break;
						
					default:
						this._minorUnit = 0;
						break;
				}
			}
		}
		
		/**
		 * @private
		 * Determines the best time unit.
		 */
		private function calculateTimeUnitSize(timeUnit:String):Number
		{
			switch(timeUnit)
			{
				case TimeUnit.YEAR:
					var year:Date = new Date(1970, 11, 31, 16);
					return year.valueOf();
				
				case TimeUnit.MONTH:
					var month:Date = new Date(1970, 0, 31, 16);
					return month.valueOf();
					
				case TimeUnit.DAY:
					var day:Date = new Date(1970, 0, 1, 16);
					return day.valueOf();
				
				case TimeUnit.HOURS:
					var hour:Date = new Date(1969, 11, 31, 17);
					return hour.valueOf();
					
				case TimeUnit.MINUTES:
					var minute:Date = new Date(1969, 11, 31, 16, 1);
					return minute.valueOf();
					
				case TimeUnit.SECONDS:
					var second:Date = new Date(1969, 11, 31, 16, 0, 1);
					return second.valueOf();
					
				default: //millisecond
					return 1;
				
			}
		}
		
		/**
		 * @private
		 * Using the major time unit, and the current minimum and maximum, generate
		 * the ideal minimum and maximum.
		 */
		private function calculateMaximumAndMinimum():void
		{
			switch(this.majorTimeUnit)
			{
				case TimeUnit.YEAR:
				{
					if(!this._minimumSetByUser)
					{
						this._minimum = new Date(this._minimum.fullYear, 0);
					}
						
					if(!this._maximumSetByUser)
					{
						var beginningOfYear:Date = new Date(this._maximum.fullYear, 0);
						//don't change the maximum if it is the exact beginning of the year
						if(beginningOfYear.valueOf() != this._maximum.valueOf())
							this._maximum = new Date(this._maximum.fullYear + 1, 0);
					}						
					break;
				}
				case TimeUnit.MONTH:
				{
					if(!this._minimumSetByUser)
						this._minimum = new Date(this._minimum.fullYear, this._minimum.month);
						
					if(!this._maximumSetByUser)
					{
						var beginningOfMonth:Date = new Date(this._maximum.fullYear, this._maximum.month);
						//don't change the maximum if it is the exact beginning of the month
						if(beginningOfMonth.valueOf() != this._maximum.valueOf())
							this._maximum = new Date(this._maximum.fullYear, this._maximum.month + 1);
					}
					break;
				}
				case TimeUnit.DAY:
				{
					if(!this._minimumSetByUser)
						this._minimum = new Date(this._minimum.fullYear, this._minimum.month, this._minimum.date);
						
					if(!this._maximumSetByUser)
					{
						var beginningOfDay:Date = new Date(this._maximum.fullYear, this._maximum.month, this._maximum.date);
						//don't change the maximum if it is the exact beginning of the day
						if(beginningOfDay.valueOf() != this._maximum.valueOf())
							this._maximum = new Date(this._maximum.fullYear, this._maximum.month, this._maximum.date + 1);
					}
					break;
				}
				case TimeUnit.HOURS:
				{
					if(!this._minimumSetByUser)
						this._minimum = new Date(this._minimum.fullYear, this._minimum.month, this._minimum.date, this._minimum.hours);
						
					if(!this._maximumSetByUser)
					{
						var beginningOfHour:Date = new Date(this._maximum.fullYear, this._maximum.month, this._maximum.date, this._maximum.hours);
						//don't change the maximum if it is the exact beginning of the day
						if(beginningOfHour.valueOf() != this._maximum.valueOf())
							this._maximum = new Date(this._maximum.fullYear, this._maximum.month, this._maximum.date, this._maximum.hours + 1);
					}
					break;
				}
				case TimeUnit.MINUTES:
				{
					if(!this._minimumSetByUser)
						this._minimum = new Date(this._minimum.fullYear, this._minimum.month, this._minimum.date, this._minimum.hours, this._minimum.minutes);
						
					if(!this._maximumSetByUser)
					{
						var beginningOfMinute:Date = new Date(this._maximum.fullYear, this._maximum.month, this._maximum.date, this._maximum.hours, this._maximum.minutes);
						//don't change the maximum if it is the exact beginning of the day
						if(beginningOfMinute.valueOf() != this._maximum.valueOf())
							this._maximum = new Date(this._maximum.fullYear, this._maximum.month, this._maximum.date, this._maximum.hours, this._maximum.minutes + 1);
					}
					break;
				}
				case TimeUnit.SECONDS:
				{
					if(!this._minimumSetByUser)
						this._minimum = new Date(this._minimum.fullYear, this._minimum.month, this._minimum.date, this._minimum.hours, this._minimum.minutes, this._minimum.seconds);
						
					if(!this._maximumSetByUser)
					{
						var beginningOfSecond:Date = new Date(this._maximum.fullYear, this._maximum.month, this._maximum.date, this._maximum.hours, this._maximum.minutes, this._maximum.seconds);
						//don't change the maximum if it is the exact beginning of the day
						if(beginningOfSecond.valueOf() != this._maximum.valueOf())
							this._maximum = new Date(this._maximum.fullYear, this._maximum.month, this._maximum.date, this._maximum.hours, this._maximum.minutes, this._maximum.seconds + 1);
					}
					break;
				}
			}
		}
		
		/**
		 * @private
		 * Calculates the multiplier used to convert a data point to an actual position
		 * on the axis.
		 */
		private function calculatePositionMultiplier():void
		{
			var range:Number = this.maximum.valueOf() - this.minimum.valueOf();
			if(range == 0)
			{
				this.positionMultiplier = 0;
				return;
			}
			this.positionMultiplier = this.renderer.length / range;
		}

		/**
		 * @private
		 */
		override protected function parseDataProvider():void
		{
			var seriesCount:int = this.dataProvider.length;
			var min:Number = NaN;
			var max:Number = NaN;
			for(var i:int = 0; i < seriesCount; i++)
			{
				var series:ISeries = ISeries(this.dataProvider[i]);
				var seriesLength:int = series.length;
				for(var j:int = 0; j < seriesLength; j++)
				{
					var item:Object = series.dataProvider[j];
					var value:Object = this.chart.itemToAxisValue(series, j, this);
					var numericValue:Number = this.valueToNumber(value);
					
					if(isNaN(min))
					{
						min = numericValue;
					}
					else
					{
						min = Math.min(min, numericValue);
					}
					if(isNaN(max))
					{
						max = numericValue;
					}
					else
					{
						max = Math.max(max, numericValue);
					}
				}
			}
			
			//bad data. show yesterday through today.
			if(isNaN(min) || isNaN(max))
			{
				var today:Date = new Date();
				max = today.valueOf();
				today.setDate(today.getDate() - 1);
				min = today.valueOf();
			}
			
			this._dataMinimum = new Date(min);
			this._dataMaximum = new Date(max);
		}		
	}
}