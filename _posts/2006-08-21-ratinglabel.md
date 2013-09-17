---
layout: post
title: RGBImageFilterでアイコンの色調を変更
category: swing
folder: RatingLabel
tags: [ImageIcon, RGBImageFilter]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-08-21

## RGBImageFilterでアイコンの色調を変更
`RGBImageFilter`で色調を変更したアイコンの用意し、評価用コンポーネントを作成します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTRfRNaARI/AAAAAAAAAhQ/8Rj6Rw8bkwU/s800/RatingLabel.png)

### サンプルコード
<pre class="prettyprint"><code>private final ImageProducer ip = orgIcon.getImage().getSource();
private ImageIcon makeStarImageIcon(float[] filter) {
  SelectedImageFilter sif = new SelectedImageFilter(filter);
  return new ImageIcon(
    createImage(new FilteredImageSource(ip, sif)));
}
private class SelectedImageFilter extends RGBImageFilter {
  private final float[] filter;
  public SelectedImageFilter(float[] filter) {
    this.filter = filter;
    canFilterIndexColorModel = false;
  }
  @Override public int filterRGB(int x, int y, int argb) {
    int r = (int)(((argb &gt;&gt; 16) &amp; 0xff) * filter[0]);
    int g = (int)(((argb &gt;&gt;  8) &amp; 0xff) * filter[1]);
    int b = (int)(((argb      ) &amp; 0xff) * filter[2]);
    return (argb &amp; 0xff000000) | (r&lt;&lt;16) | (g&lt;&lt;8) | (b);
  }
}
</code></pre>

### 解説
上記のサンプルは、`RGBImageFilter`を使用して、一つのアイコンから複数の色の異なるアイコンを生成し、`5`段階の評価を行うコンポーネントを作成しています。クリックしたアイコンの位置が評価レベルになります。

### 参考リンク
- [PI Diagona Icons Pack 1.0 - Download Royalty Free Icons and Stock Images For Web & Graphics Design](http://www.freeiconsdownload.com/Free_Downloads.asp?id=60)
    - アイコンを利用しています。

<!-- dummy comment line for breaking list -->

### コメント
- 素晴しい！：）--  2006-08-23 (水) 17:34:40
    - どうもです。 -- [aterai](http://terai.xrea.jp/aterai.html)
- メモ: 一般的？には`Rating Bar`と言うみたいです。[Masuga Design » Unobtrusive AJAX Star Rating Bar](http://www.masugadesign.com/the-lab/scripts/unobtrusive-ajax-star-rating-bar/) -- [aterai](http://terai.xrea.jp/aterai.html) 2006-11-07 (火) 12:38:34
- アイコンを変更、アイコンの間隔を設定 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-10-20 (月) 18:20:50
- スクリーンショットを更新 -- [aterai](http://terai.xrea.jp/aterai.html) 2008-11-25 (火) 11:19:25

<!-- dummy comment line for breaking list -->

