﻿package com.yahoo.astra.fl.charts.axes
{
	import com.yahoo.astra.fl.charts.series.ISeries;
	import fl.core.UIComponent;
	import flash.text.TextFormat;	
	import com.yahoo.astra.utils.TextUtil;
	/**
	 * An axis type representing a set of categories.
	 * 
	 * @author Josh Tynjala
	 */
	public class CategoryAxis extends BaseAxis implements IAxis, IClusteringAxis
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function CategoryAxis()
		{
		}
		
	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * Used to determine the position of an item based on a value.
		 */
		protected var categorySize:Number = 0;
		
		/**
		 * @private
		 * Storage for the categoryNames property.
		 */
		private var _categoryNames:Array = [];
		
		/**
		 * @private
		 * Indicates whether the category labels are user-defined or generated by the axis.
		 */
		private var _categoryNamesSetByUser:Boolean = false;
		
		/**
		 * The category labels to display along the axis.
		 */
		public function get categoryNames():Array
		{
			return this._categoryNames;
		}
		
		/**
		 * @private
		 */
		public function set categoryNames(value:Array):void
		{
			this._categoryNamesSetByUser = value != null && value.length > 0;
			if(this._categoryNamesSetByUser)
			{
				this._categoryNames = [];
			}
			else
			{
				//ensure that all category names are strings
				this._categoryNames = getCategoryNames(value);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get clusterCount():int
		{
			return this.categoryNames.length;
		}

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
		}		
		
		/**
		 * @private
		 */
		private var _majorUnit:Number = 1; 
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function valueToLocal(value:Object):Number
		{
			if(value === null)
			{
				return NaN;
			}
			
			var index:int = this.categoryNames.indexOf(value.toString());
			if(index >= 0)
			{
				var position:int = this.categorySize * index + (this.categorySize / 2);
				if(this.reverse)
				{
					position = this.renderer.length - position;
				}
				return position;
			}
			return NaN;
		}
	
		/**
		 * @inheritDoc
		 */
		public function updateScale():void
		{
			if(!this._categoryNamesSetByUser)
			{
				this.autoDetectCategories(this.dataProvider);
			}
			this.calculateCategorySize();
		}

		/**
		 * @inheritDoc
		 */
		public function getMaxLabel():String
		{
			var categoryCount:int = this.categoryNames.length;
			var maxLength:Number = 0;
			var currentLength:Number;
			var maxString:String = "x";

			for(var i:int = 0; i < categoryCount; i++)
			{
				currentLength = (this.categoryNames[i].toString()).length; 

				if(currentLength > maxLength)
				{
					maxLength = currentLength;
					maxString = this.categoryNames[i];
				}
			}			
			
			return maxString as String;	
		}

	//--------------------------------------
	//  Private Methods
	//--------------------------------------
	
		/**
		 * @private
		 * Update the labels by adding or removing some, setting the text, etc.
		 */
		private function autoDetectCategories(data:Array):void
		{
			var uniqueCategoryNames:Array = [];
			var seriesCount:int = data.length;
			for(var i:int = 0; i < seriesCount; i++)
			{
				var series:ISeries = data[i] as ISeries;
				if(!series)
				{
					continue;
				}
				
				var seriesLength:int = series.length;
				for(var j:int = 0; j < seriesLength; j++)
				{
					var category:Object = this.chart.itemToAxisValue(series, j, this);
					
					//names must be unique
					if(uniqueCategoryNames.indexOf(category) < 0)
					{
						uniqueCategoryNames.push(category);
					}
				}
			}
			this._categoryNames = getCategoryNames(uniqueCategoryNames.concat());
		}
		
		/**
		 * @private
		 * Determines the amount of space provided to each category.
		 */
		private function calculateCategorySize():void
		{
			var categoryCount:int = this.categoryNames.length;
			this.categorySize = this.renderer.length;
			if(categoryCount > 0)
			{
				this.categorySize /= categoryCount;
			}
			
			//If the number of labels will not fit on the axis or the user has specified the number of labels to
			//display, calculate the major unit. 
			if(this.categorySize < this.maxLabelWidth || (this._numLabelsSetByUser && this.numLabels != categoryCount))
			{
				this.calculateMajorUnit();
			} 
		}
		
		/**
		 * @private
		 * Calculates which labels to skip if they will not all fit on the axis.
		 */
		private function calculateMajorUnit():void
		{
			var categoryCount:int = this.categoryNames.length;
			var maxNumLabels:Number = this.renderer.length/this.maxLabelWidth;
			
			//If the user specified number of labels to display, attempt to show the correct number.
			if(this._numLabelsSetByUser)
			{
				maxNumLabels = Math.min(maxNumLabels, this.numLabels);
			}
			
			var tempMajorUnit:Number = Math.ceil(this.categoryNames.length/maxNumLabels);
			this._majorUnit = tempMajorUnit;			
			if(this.renderer.length%tempMajorUnit != 0 && !this._numLabelsSetByUser)
			{
				var len:Number = Math.min(tempMajorUnit, ((this.renderer.length/2)-tempMajorUnit));
				for(var i:int = 0;i < len; i++)
				{
					tempMajorUnit++;
					if(this.renderer.length%tempMajorUnit == 0)
					{
						this._majorUnit = tempMajorUnit;
						break;
					}
				}
			}	
		}
		
		/**
		 * @private 
		 * Ensures all values in an array are string values
		 */
		private function getCategoryNames(value:Array):Array
		{
			var names:Array = [];
			if(value != null && value.length > 0)
			{
				for(var i:int = 0; i < value.length; i++)
				{
					names.push(value[i].toString());
				}
			}
			return names;
		}

		/**
		 * @private
		 */
		override protected function parseDataProvider():void
		{
			var ticks:Array = [];
			var categoryCount:int = this.categoryNames.length;
			var currentCat:int = 0;
			while(currentCat < categoryCount && !isNaN(categoryCount))
			{
				var category:String = this.categoryNames[currentCat];
				var position:Number = this.valueToLocal(category);
				var label:String = this.valueToLabel(category);
				var axisData:AxisData = new AxisData(position, category, label);
				ticks.push(axisData);
				currentCat += this._majorUnit;
			}
				
			this.renderer.ticks = ticks;
			this.renderer.minorTicks = [];				
		}		
	}
}