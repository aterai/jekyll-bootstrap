---
layout: post
category: swing
folder: HTMLImgBaseline
title: JEditorPaneに配置したImgタグのvertical-alignを変更する
tags: [JEditorPane, HTML]
author: aterai
pubdate: 2017-09-11T15:39:55+09:00
description: JEditorPaneに配置したImgタグのvertical-alignをベースライン揃えに変更します。
image: https://drive.google.com/uc?id=1SHPkR8vKbzKY6zpuM6eQL0c_ci02zOsLcw
comments: true
---
## 概要
`JEditorPane`に配置した`Img`タグの`vertical-align`をベースライン揃えに変更します。

{% download https://drive.google.com/uc?id=1SHPkR8vKbzKY6zpuM6eQL0c_ci02zOsLcw %}

## サンプルコード
<pre class="prettyprint"><code>class ImgBaselineHTMLEditorKit extends HTMLEditorKit {
  @Override public ViewFactory getViewFactory() {
    return new HTMLEditorKit.HTMLFactory() {
      @Override public View create(Element elem) {
        View view = super.create(elem);
        if (view instanceof LabelView) {
          System.out.println("debug: " + view.getAlignment(View.Y_AXIS));
        }
        AttributeSet attrs = elem.getAttributes();
        Object elementName = attrs.getAttribute(AbstractDocument.ElementNameAttribute);
        Object o = Objects.nonNull(elementName)
            ? null
            : attrs.getAttribute(StyleConstants.NameAttribute);
        if (o instanceof HTML.Tag) {
          HTML.Tag kind = (HTML.Tag) o;
          if (kind == HTML.Tag.IMG) {
            return new ImageView(elem) {
              @Override public float getAlignment(int axis) {
                // .8125f magic number...
                return axis == View.Y_AXIS ? .8125f : super.getAlignment(axis);
              }
            };
          }
        }
        return view;
      }
    };
  }
}
</code></pre>

## 解説
- 上
    - `<img>`タグで挿入した画像がインラインボックスからずれて表示される
    - `img {align: middle; valign: middle; vertical-align: middle;}`などの設定が無効
    - `javax/swing/text/html/ImageView.java`の`setPropertiesFromAttributes()`の実装は、以下のように`HTML.Attribute.VERTICAL_ALIGN`ではなく`HTML.Attribute.ALIGN`を使用することで、少なくとも`top`, `middle`が使用できるはずだが、`Java 1.8.0_144`ではこれらを設定しても全く効果がない？
        
        <pre class="prettyprint"><code>/**
         * Update any cached values that come from attributes.
         */
        // @see javax/swing/text/html/ImageView.java
        protected void setPropertiesFromAttributes() {
          StyleSheet sheet = getStyleSheet();
          this.attr = sheet.getViewAttributes(this);
          // ...
          AttributeSet attr = getElement().getAttributes();
          // Alignment.
          // PENDING: This needs to be changed to support the CSS versions
          // when conversion from ALIGN to VERTICAL_ALIGN is complete.
          Object alignment = attr.getAttribute(HTML.Attribute.ALIGN);
          vAlign = 1.0f;
          if (alignment != null) {
            alignment = alignment.toString();
            if ("top".equals(alignment)) {
              vAlign = 0f;
            } else if ("middle".equals(alignment)) {
              vAlign = .5f;
            }
          }
          // ...
</code></pre>
- 下
    - `ImageView#getAlignment(...)`メソッドをオーバーライドして、`vertical-align`を直接指定する`HTMLFactory`を作成し、`HTMLEditorKit#getViewFactory()`メソッドで使用するよう設定
    - 上記のサンプルでは、画像サイズをデフォルトフォントのサイズと同じに設定し、ベースラインも同じ値を使用するよう固定している

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JDK-5094219 JEditorPane doesn't recognize CSS vertical-align property - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-5094219)
- [ImageView#getAlignment(...) (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/text/html/ImageView.html#getAlignment-int-)
- [JTextPaneに追加するコンポーネントのベースラインを揃える](https://ateraimemo.com/Swing/InsertComponentBaseline.html)

<!-- dummy comment line for breaking list -->

## コメント
