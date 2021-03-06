---
layout: post
category: swing
folder: SurrogatePair
title: JTextComponentでサロゲートペアのテスト
tags: [JEditorPane, JTextComponent, Unicode, Fixed]
author: aterai
pubdate: 2012-05-14T11:54:26+09:00
description: JEditorPaneなどで数値文字参照やUnicodeエスケープを使ってサロゲートペアのテストをします。
image: https://lh5.googleusercontent.com/-BY6N3kDDUG8/T7ByWIn0mgI/AAAAAAAABMo/4dpU-rm8zAQ/s800/SurrogatePair.png
comments: true
---
## 概要
`JEditorPane`などで数値文字参照や`Unicode`エスケープを使ってサロゲートペアのテストをします。

{% download https://lh5.googleusercontent.com/-BY6N3kDDUG8/T7ByWIn0mgI/AAAAAAAABMo/4dpU-rm8zAQ/s800/SurrogatePair.png %}

## サンプルコード
<pre class="prettyprint"><code>final URL url = getClass().getResource("SurrogatePair.html");
try (Reader reader = new InputStreamReader(url.openStream(), StandardCharsets.UTF_8)) {
  editor1.read(reader , "html");
} catch (Exception ex) {
  editor1.setText(
    "&lt;html&gt;&lt;p&gt;(&amp;#xD85B;&amp;#xDE40;) (&amp;#x26E40;)&lt;br /&gt;(&amp;#xD842;&amp;#xDF9F;) (&amp;#x00020B9F;)&lt;/p&gt;&lt;/html&gt;");
}

JEditorPane editor2 = new JEditorPane();
//editor2.setFont(new Font("IPAexGothic", Font.PLAIN, 24));
editor2.putClientProperty(JEditorPane.HONOR_DISPLAY_PROPERTIES, Boolean.TRUE);
editor2.setText("(\uD85B\uDE40) (\u26E40)\n(\uD842\uDF9F) (\u20B9F)");
</code></pre>

## 解説
以下、サロゲートペア対応フォントを使えるようにしてテストしています。`Java Web Start`で起動した場合、このサンプルの`browse`ボタンで`jar`ファイル内の`SurrogatePair.html`を表示することはできません。

- 上: 数値文字参照(`Numeric character reference`)
    - [Bug ID: 6836089 Swing HTML parser can't properly decode codepoints outside the Unicode Plane 0 into a surrogate pair](https://bugs.openjdk.java.net/browse/JDK-6836089)で修正されたので、`&#x26E40;`などでも正常に文字が表示される(上記のスクリーンショットのように文字化けしない)
    - `JEditorPane(HTMLEditorKit)`の場合
        - `JEditorPane` + `&#xD85B;&#xDE40;`: `OK`
        - `JEditorPane` + `&#x26E40;`: `~~NG~~` `OK`

<!-- dummy comment line for breaking list -->

    - ブラウザ(試したのは`IE`, `FireFox`, `Chrome`, `Opera`)の場合
        - `Browser` + `&#xD85B;&#xDE40;`: `NG`
        - `Browser` + `&#x26E40;`: `OK`

<!-- dummy comment line for breaking list -->

- 下: `Unicode`エスケープ(`Unicode escapes`)
        - `JEditorPane` + `\uD85B\uDE40`: `OK`
        - `JEditorPane` + `\u26E40`: `NG`

<!-- dummy comment line for breaking list -->

- - - -
- `JTextComponent`とブラウザでサロゲートペアの表現が異なるため、これらの文字をどちらの環境でも正しく表示したい場合は、数値文字参照や`Unicode`エスケープは使用せず、ソースコードなどを`UTF-8`にしてそのまま𦹀や𠮟と書く(メモ帳などの対応済みエディタで)ほうが良さそう
- `Windows 7`, `JDK 1.7.0_02`の環境では、`JTextComponent`からメモ帳などにサロゲートペアの文字をコピーペーストは可能だが、逆にメモ帳やブラウザから`JTextComponent`にサロゲートペアの文字をコピーペーストは不可
- `JTextComponent`(`Java 1.7.0`)は、異体字セレクタに対応してない
    - フォントを`IVS`に対応している`IPAmj明朝`などに変更し、異体字セレクタ付き文字列のある`UTF-8`のテキストを`JTextArea`などに読み込んでも異体字セレクタが〓になる
    - 数値文字参照、`Unicode`エスケープを使う方法でも〓になる
    - [Java IVSの異体字を元の字と同一視して比較する - terazzoの日記](http://d.hatena.ne.jp/terazzo/20110115/1295047469)のように、`VS`を`UTF-16`に(例えば`U+E0101`を`\uDB40\uDD01`に)しても、`JTextComponent`では駄目

<!-- dummy comment line for breaking list -->

- - - -
- 参考メモ: [MS IVSアドインでDTPにはどんな影響があるのか - ちくちく日記](http://d.hatena.ne.jp/akane_neko/20121115/1352932112)
    - `Adobe-Japan1 collection`: `小塚明朝 Pr6N`など
    - `Hanyo-Denshi collection`: `IPAmj明朝`など

<!-- dummy comment line for breaking list -->


- - - -
- ~~`Windows 10 64bit`、`JDK 1.8.0_112`、`小塚明朝 Pr6N R`(`KozMinPr6N-Regular.otf`)で、`Font.createFont(...)`を使って`Font`を作成すると`IllegalArgumentException`が発生する場合がある~~
    - ~~例外が発生しなくても、文字は正常に表示されない~~
    - [JDK-5092191 RFE: CFF/Type2 embedded fonts not supported with Font.createFont() - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-5092191)
    - [JDK-8074562 CID keyed OpenType fonts are not supported by T2K - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8074562)
    - [JDK-8168288 Dubious FontMetrics values from NullFontScaler - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-8168288)
        - `Java 9`、`8u152`で修正された

<!-- dummy comment line for breaking list -->

	Exception in thread "AWT-EventQueue-0" java.lang.IllegalArgumentException: Length must be >= 0.
	   at javax.swing.text.GlyphPainter2.getBoundedPosition(GlyphPainter2.java: 205)

<pre class="prettyprint"><code>import java.awt.*;
import java.io.*;
import java.net.*;
import javax.swing.*;

public class OTFTest {
  public JComponent makeUI() {
    JTextArea textArea = new JTextArea("1234567890\n \uD85B\uDE40");
    String str = "file:///C:/Program Files (x86)/Adobe/Acrobat 2015/Resource/CIDFont/KozMinPr6N-Regular.otf";
    //String str = "file:///C:/Program Files (x86)/Adobe/Reader 11.0/Resource/CIDFont/KozMinPr6N-Regular.otf";
    //String str = "file:///C:/Windows/Fonts/meiryo.ttc";
    //String str = "file:///C:/Windows/Fonts/ipaexg.ttf";
    //String str = "file:///C:/Windows/Fonts/A-OTF-ShinGoPro-Regular.otf";
    try (InputStream is = new URL(str).openStream()) {
      //textArea.setFont(Font.createFont(Font.TRUETYPE_FONT, is));
      textArea.setFont(Font.createFont(Font.TRUETYPE_FONT, is).deriveFont(32f));
    } catch (IOException | FontFormatException ex) {
      ex.printStackTrace();
    }
    JPanel p = new JPanel(new BorderLayout());
    p.add(new JScrollPane(textArea));
    return p;
  }
  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      @Override public void run() {
        createAndShowGUI();
      }
    });
  }
  public static void createAndShowGUI() {
    JFrame f = new JFrame();
    f.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
    f.getContentPane().add(new OTFTest().makeUI());
    f.setSize(320, 240);
    f.setLocationRelativeTo(null);
    f.setVisible(true);
  }
}
</code></pre>

## 参考リンク
- [Java Font Support - OpenType : Java Glossary](http://mindprod.com/jgloss/opentype.html#JAVASUPPORT)
- [OpenType (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/font/OpenType.html)
- [Java access files in jar causes java.nio.file.FileSystemNotFoundException - Stack Overflow](https://stackoverflow.com/questions/22605666/java-access-files-in-jar-causes-java-nio-file-filesystemnotfoundexception)

<!-- dummy comment line for breaking list -->

## コメント
- 結合文字(`A&#x0300;`、`か&#x3099;`)も`JTextComponent`は未対応。~~ブラウザだと`Chrome`は対応されているが、他は部分的な対応になっている？~~ -- *aterai* 2012-05-15 (火) 11:17:30
- `Windows 7` + `JDK 1.7.0`で`OTF`フォントは使えない？？？ -- *aterai* 2012-06-06 (水) 19:07:01
- メモ: [Bug ID: 6836089 Swing HTML parser can't properly decode codepoints outside the Unicode Plane 0 into a surrogate pair](https://bugs.openjdk.java.net/browse/JDK-6836089) -- *aterai* 2012-06-25 (月) 18:37:16
    - via: [<Swing Dev> <Swind Dev> <7u6> Review request for 6836089: Swing HTML parser can't properly decode codepoints outside the Unicode Plane 0 into a surrogate pair](http://mail.openjdk.java.net/pipermail/swing-dev/2012-June/002145.html)
    - 確かに`JDK 1.6.0_33`では、`&#x26E40;`などの数値文字参照が`JEditorPane`で正常に表示されている。 -- *aterai* 2012-06-25 (月) 20:42:16

<!-- dummy comment line for breaking list -->
