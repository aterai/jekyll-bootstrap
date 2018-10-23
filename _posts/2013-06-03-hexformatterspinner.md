---
layout: post
category: swing
folder: HexFormatterSpinner
title: JSpinnerの表記を16進数にする
tags: [JSpinner, DefaultFormatter, Font]
author: aterai
pubdate: 2013-06-03T04:18:20+09:00
description: JSpinnerの表記を16進数にして、そのUnicodeコードポイントに割り当てられた文字を表示します。
image: https://lh4.googleusercontent.com/-eTZU_kuJGK4/UauUgRcPuTI/AAAAAAAABtc/7FNouA9JcLI/s800/HexFormatterSpinner.png
comments: true
---
## 概要
`JSpinner`の表記を`16`進数にして、その`Unicode`コードポイントに割り当てられた文字を表示します。

{% download https://lh4.googleusercontent.com/-eTZU_kuJGK4/UauUgRcPuTI/AAAAAAAABtc/7FNouA9JcLI/s800/HexFormatterSpinner.png %}

## サンプルコード
<pre class="prettyprint"><code>private static DefaultFormatterFactory makeFFactory() {
  DefaultFormatter formatter = new DefaultFormatter() {
    @Override public Object stringToValue(String text) throws ParseException {
      return Integer.valueOf(text, 16);
    }
    @Override public String valueToString(Object value) throws ParseException {
      return String.format("%06X", (Integer) value);
    }
  };
  formatter.setValueClass(Integer.class);
  formatter.setOverwriteMode(true);
  return new DefaultFormatterFactory(formatter);
}
</code></pre>

## 解説
上記のサンプルでは、`DefaultFormatter#stringToValue(String)`と`DefaultFormatter#valueToString(Object)`をオーバーライドして、`0x0`から`0x10FFFF`までの整数を`16`進数で表示する`Formatter`を作成して`JSpinner`に設定しています。

- - - -
`JSpinner`から取得した数値(コードポイント)から文字を生成する時、サロゲートペアなどの基本多言語面(`BMP`)外に対応するために、[Sample Usage (The Java™ Tutorials > Internationalization > Working with Text)](https://docs.oracle.com/javase/tutorial/i18n/text/usage.html)を参考にして、以下のような方法を使用しています。

<pre class="prettyprint"><code>int code = ((Integer) spinner.getValue()).intValue();
//char[] ca = Character.toChars(code);
String str = new String(Character.toChars(code));
</code></pre>

- - - -
[IPAmj明朝](http://mojikiban.ipa.go.jp/download.html)と[IPAex明朝](http://ipafont.ipa.go.jp/)フォントがインストールされている場合、その文字の形の違いを比較できます。

## 参考リンク
- [Fontのアウトラインを取得して文字列の内部を修飾する](https://ateraimemo.com/Swing/LineSplittingLabel.html)
- [IPAmj明朝フォント | 文字情報基盤整備事業](http://mojikiban.ipa.go.jp/1300.html)
- [IPAexフォント/IPAフォント](http://ipafont.ipa.go.jp/)
- [IPAmj明朝とIPAex明朝で形の違う字 NAOI's fotolife - 20130411131759](http://f.hatena.ne.jp/NAOI/20130411131759)

<!-- dummy comment line for breaking list -->

## コメント
