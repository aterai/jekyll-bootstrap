---
layout: post
title: UIManagerで使用するFontを統一
category: swing
folder: FontChange
tags: [UIManager, Font]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2003-10-27

## UIManagerで使用するFontを統一
`Swing`の各種コンポーネントで使用する全てのフォントを一気に変更します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](http://lh4.ggpht.com/_9Z4BYR88imo/TQTNJ5XQrjI/AAAAAAAAAaU/lvxCohYLmBI/s800/FontChange.png)

### サンプルコード
<pre class="prettyprint"><code>private void updateFont(final Font font) {
  FontUIResource fontUIResource = new FontUIResource(font);
  for(java.util.Map.Entry&lt;?,?&gt; entry: UIManager.getDefaults().entrySet()) {
    if(entry.getKey().toString().toLowerCase().endsWith("font")) {
      UIManager.put(entry.getKey(), fontUIResource);
    }
  }
  //SwingUtilities.updateComponentTreeUI(this);
  recursiveUpdateUI(this);
  frame.pack();
}
private void recursiveUpdateUI(JComponent p) {
  for(Component c: p.getComponents()) {
    if(c instanceof JToolBar) {
      continue;
    }else if(c instanceof JComponent) {
      JComponent jc = (JComponent)c;
      jc.updateUI();
      if(jc.getComponentCount()&gt;0) recursiveUpdateUI(jc);
    }
  }
}
</code></pre>

### 解説
上記のサンプルでは、ツールバーのボタンでコンポーネントが使用するフォントを切り替えています。ただしツールバーだけは、`UI`の`update`(フォントの変更)を除外しています。

全部のコンポーネントではなく、例えばテーブルのフォントだけ変更したい場合は以下のように設定します。

<pre class="prettyprint"><code>UIManager.put("Table.font", new FontUIResource(font));
</code></pre>

`UIManager`から、`UIDefaults`のキー一覧を作るなどして、いろいろ検索してみてください。

<pre class="prettyprint"><code>//キー一覧の作成例
import java.util.Map;
import javax.swing.UIManager;
class Test {
  public static void main(String[] args) {
    //for(Object o:UIManager.getDefaults().keySet()) //は、うまくいかない？
    //for(Object o:UIManager.getLookAndFeelDefaults().keySet())
    for(Map.Entry&lt;?,?&gt; entry: UIManager.getDefaults().entrySet())
      System.out.println(entry.getKey());
  }
}
</code></pre>

この方法は、一々[LookAndFeel](http://java.sun.com/products/jlf/ed2/book/HIG.Glossary.html#51529)を作成してフォントを変更するのが面倒なときには便利です。[LookAndFeel](http://java.sun.com/products/jlf/ed2/book/HIG.Glossary.html#51529)を自作する場合は、以下などを参考にしてみてください。

- [Developing Accessible JFC Applications](http://www.sun.com/access/developers/developing-accessible-apps/)
    - [Appendix A - LowVisionMetalLookAndFeel](http://www.sun.com/access/developers/developing-accessible-apps/appendix.html)
- [自分だけのカッコ良いアプリを作りたい，の巻](http://www2u.biglobe.ne.jp/~kaduhiko/java_09.html)

<!-- dummy comment line for breaking list -->

- - - -
`Metal`で使用されているフォントが気に入らないといった場合は、システム`LookAndFeel`を使用するか、`Metal`でボールドフォントを無効にするなどの方法があります。

- `MetalLookAndFeel`ではなく、`SystemLookAndFeel`を使用する

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>try{
  UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
}catch(Exception e) {
  e.printStackTrace();
}
</code></pre>

- `MetalLookAndFeel`で、`bold fonts`を無効にする場合
    - [MetalLookAndFeelで太字フォントを使用しない](http://terai.xrea.jp/Swing/BoldMetal.html)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>UIManager.put("swing.boldMetal", Boolean.FALSE);
</code></pre>

- - - -
- `JComboBox#setFont`をしても、`JComboBox`自体のサイズが更新されない
    - [JCombobox doesn't get resized according to font size change](http://bugs.sun.com/bugdatabase/view_bug.do?bug_id=5006246)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>combo.setFont(font);
//以下回避方法
combo.setPrototypeDisplayValue(null); //null:default?
//or combo.firePropertyChange("prototypeDisplayValue",0,1); //0,1:dummy
</code></pre>

- - - -
特定のインスタンスだけ、`LookAndFeel`などを変更しても常に独自のフォントを設定したい場合、`JComponent#updateUI()`をオーバーライドして設定する方法もあります。

<pre class="prettyprint"><code>JLabel label = new JLabel() {
  @Override public void updateUI() {
    super.updateUI();
    setFont(...);
  }
};
</code></pre>

### 参考リンク
- [Re: setFont に関して](http://java-house.jp/ml/archive/j-h-b/049474.html)

<!-- dummy comment line for breaking list -->

### コメント
- `JFileChooser`インスタンス化前に上記ソースを実行すると `ConcurrentModificationException`がスローされるのですが... 「`JDK1.4.2_02`」プロパティーが動的に変化するとしたらあまり有効な方法でないのでは? -- [MT](http://terai.xrea.jp/MT.html) 2003-12-24 (水) 14:22:15
- 割と手軽なので重宝するのですが、ちゃんとスレッド処理考えたほうがいいのかもしれませんね。 -- [aterai](http://terai.xrea.jp/aterai.html) 2003-12-25 (木) 20:06:15
- レスありがとうございます _ _)m とりあえず `Container` を辿りながら含まれている `Component` 毎に `setFont` 呼ぶようなユーティリティ用意してしのいでいます＾＾； -- [MT](http://terai.xrea.jp/MT.html) 2003-12-26 (金) 16:20:14
- `UIManager`のリストにないコンポーネント（独自で作成したボタンなどのコンポーネント）なども追加すると変更が適用されるのでしょうか？ -- [mari](http://terai.xrea.jp/mari.html) 2004-01-22 (木) 10:53:29
- `JButton`などの`Swing`コンポーネントを継承していれば変更されるはずです。 -- [aterai](http://terai.xrea.jp/aterai.html) 2004-01-22 (木) 11:46:40
- レスありがとうございます。その場合、独自のコンポーネントを追加すると、そのコンポーネントのみ変更が適用されますか？`Panel`を追加したら全ての`panel`に適用されてしまってうまくいきませんでした。良い方法があったら教えてください。 -- [mari](http://terai.xrea.jp/mari.html) 2004-01-23 (金) 10:24:45
- すべてのコンポーネントに一々設定するのが面倒な場合のための方法なので、上記の場合は使用する意味が無いですね(^^;。ある独自コンポーネントのみフォントを変えたいのなら、コンストラクタなどで普通に`setFont`すればいいのでないかと思うのですが、どうなんでしょう？そうじゃなくて、あるパネル以下のコンポーネントのフォントを一気に変えたいということなんでしょうか？ -- [aterai](http://terai.xrea.jp/aterai.html) 2004-01-23 (金) 12:13:27
- たびたびすみません。全体のフォントの大きさをツールバーの選択によって変化させるようにしたいです。フォントだけ変化させたいのですが、コンストラクタなどで勝手に`setBackground`しているコンポーネントは`Look and Feel`で設定しているデフォルトの`background`に変わってしまいました。また`new`するわけではないので、そのコンポーネントのみのデフォルトをどこかで設定できたらいいなー、と思いました。`Look and Feel`でも`panel`だったら`panel`全ての設定しかできないのでしょうか？有効な方法があったら教えてください。よろしくお願いいたします。 -- [mari](http://terai.xrea.jp/mari.html) 2004-01-23 (金) 14:05:47
- `Look and Feel`で変更するのではなく、イベントリスナーを作って実装するのはどうでしょう？はずしてるかもしれませんが、とりあえずサンプル置いておきます。初期値はコンストラクタで指定してます。ツールバーじゃなくてメニューで、フォントを切り替えてます。コンボボックスを切り替えたときにサイズがおかしいのは愛嬌ということで…。 -- [aterai](http://terai.xrea.jp/aterai.html) 2004-01-23 (金) 15:39:27
    - [EventListenerを実装して独自イベント作成](http://terai.xrea.jp/Swing/EventListener.html)
- すばらしいサンプルありがとうございます！参考にさせていただきました☆フォントの変更を`Look and Feel`で行って、残りの描画できなかった背景色などを`PropertyChangeListenerを`実装して描画しなおす、という方法も考えたのですが、こちらでも問題ないでしょうか？主題から外れてしまって申し訳ありません・・・。 -- [mari](http://terai.xrea.jp/mari.html) 2004-01-26 (月) 09:56:38
- 次のネタ用にイベント作っただけなので、`PropertyChangeListener`使うのはまったく問題ないと思います。むしろちゃんと`JavaBeans`にして`PropertyChangeListener`使うほうがいいかもしれません(^^;。 -- [aterai](http://terai.xrea.jp/aterai.html) 2004-01-26 (月) 12:54:00
- updateUI()をオーバーライドする方法を追記。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-02-26 (火) 16:15:09
- `Nimbus`の場合は、この方法では駄目でした。バグのようです。回避策は、`UIManager.getLookAndFeelDefaults().put("defaultFont", new Font(Font.SANS_SERIF, 0, 20));`をフレームを`new`する前に実行する事でした。 参考：[swing - Java: Altering UI fonts (Nimbus) doesn't work! - Stack Overflow](http://stackoverflow.com/questions/949353/java-altering-ui-fonts-nimbus-doesnt-work) -- [匿名](http://terai.xrea.jp/匿名.html) 2013-05-25 (土) 09:14:08
    - 情報ありがとうございます。これバグだとすると修正されるのかな？(仕様になりそうな気がしますが) 参考のリンク先にあるjasperpotts.comの`Nimbus Defaults`一覧が便利ですね(チュートリアル[Nimbus Defaults (The Java™ Tutorials > Creating a GUI With JFC/Swing > Modifying the Look and Feel)](http://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/_nimbusDefaults.html)にも転載されています)。このサイトでは、そちらを参考にして`NimbusLookAndFeel`の色をまとめて変換するサンプル([NimbusLookAndFeelのカラーパレット](http://terai.xrea.jp/Swing/NimbusColorPalette.html))を作成しています。 -- [aterai](http://terai.xrea.jp/aterai.html) 2013-05-26 (日) 00:51:21

<!-- dummy comment line for breaking list -->
