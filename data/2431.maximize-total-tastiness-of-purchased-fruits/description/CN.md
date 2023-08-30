## [2431.最大限度地提高购买水果的口味]
<p>你有两个非负整数数组 <code>price</code> 和 <code>tastiness</code>，两个数组的长度都是 <code>n</code>。同时给你两个非负整数 <code>maxAmount</code> 和 <code>maxCoupons</code>。</p>

<p data-group="1-1">对于范围 <code>[0, n - 1]</code>&nbsp;中的每一个整数 <code>i</code>:</p>

<ul>
	<li>
	<p data-group="1-1"><code>price[i]</code>&nbsp;描述了第 <code>i</code> 个水果的价格。</p>
	</li>
	<li><code>tastiness[i]</code> 描述了第 <code>i</code> 个水果的味道。</li>
</ul>

<p>你想购买一些水果，这样总的味道是最大的，总价不超过 <code>maxAmount</code>。</p>

<p>此外，你还可以用优惠券以&nbsp;<strong>半价 </strong>购买水果 (向下取整到最接近的整数)。您最多可以使用 <code>maxCoupons</code>&nbsp;次该优惠券。</p>

<p>返回可购买的最大总口味。</p>

<p><strong>注意:</strong></p>

<ul>
	<li>每种水果最多只能购买一次。</li>
	<li>一些水果你最多只能用一次折价券。</li>
</ul>

<p>&nbsp;</p>

<p><strong>示例 1:</strong></p>

<pre>
<strong>输入:</strong> price = [10,20,20], tastiness = [5,8,8], maxAmount = 20, maxCoupons = 1
<strong>输出:</strong> 13
<strong>解释:</strong> 可以用以下方法来达到总口味:
- 无优惠券买第一个水果，总价= 0 + 10，总口味= 0 + 5。
- 用优惠券买第二个水果，总价= 10 + 10，总口味= 5 + 8。
- 不购买第三个水果，总价= 20，总口味= 13。
可以证明 13 是所能得到的最大总口味。
</pre>

<p><strong>示例 2:</strong></p>

<pre>
<strong>输入:</strong> price = [10,15,7], tastiness = [5,8,20], maxAmount = 10, maxCoupons = 2
<strong>输出:</strong> 28
<strong>解释:</strong> 可以用以下方法使总口味达到 20:
- 不买第一个水果，这样总价= 0，总口味= 0。
- 用优惠券买第二个水果，总价= 0 + 7，总口味= 0 + 8。
- 用优惠券买第三个水果，总价= 7 + 3，总口味= 8 + 20。
可以证明，28 是所能得到的最大总口味。
</pre>

<p>&nbsp;</p>

<p><strong>提示:</strong></p>

<ul>
	<li><code>n == price.length == tastiness.length</code></li>
	<li><code>1 &lt;= n &lt;= 100</code></li>
	<li><code>0 &lt;= price[i], tastiness[i], maxAmount &lt;= 1000</code></li>
	<li><code>0 &lt;= maxCoupons &lt;= 5</code></li>
</ul>
