---
layout: post
category: swing
folder: FontChange
title: UIManagerで使用するFontを統一
tags: [UIManager, Font]
author: aterai
pubdate: 2003-10-27
description: Swingの各種コンポーネントで使用する全てのフォントを一気に変更します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTNJ5XQrjI/AAAAAAAAAaU/lvxCohYLmBI/s800/FontChange.png
comments: true
---
## 概要
`Swing`の各種コンポーネントで使用する全てのフォントを一気に変更します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTNJ5XQrjI/AAAAAAAAAaU/lvxCohYLmBI/s800/FontChange.png %}

## サンプルコード
<pre class="prettyprint"><code>private void updateFont(final Font font) {
  FontUIResource fontUIResource = new FontUIResource(font);
  // for (Map.Entry&lt;?, ?&gt; entry: UIManager.getDefaults().entrySet()) {
  UIManager.getLookAndFeelDefaults().forEach((key, value) -&gt; {
    if (key.toString().toLowerCase(Locale.ENGLISH).endsWith("font")) {
      UIManager.put(key, fontResource);
    }
  });
  // SwingUtilities.updateComponentTreeUI(this);
  recursiveUpdateUI(this);
  frame.pack();
}
private void recursiveUpdateUI(JComponent p) {
  for (Component c: p.getComponents()) {
    if (c instanceof JToolBar) {
      continue;
    } else if (c instanceof JComponent) {
      JComponent jc = (JComponent) c;
      jc.updateUI();
      if (jc.getComponentCount() &gt; 0) {
        recursiveUpdateUI(jc);
      }
    }
  }
}
</code></pre>

## 解説
上記のサンプルでは、ツールバーのボタンでコンポーネントが使用するフォントを切り替えています。ただしツールバーだけは、`UI`の`update`(フォントの変更)を除外しています。

- - - -
- 全コンポーネントではなく、例えば`JTable`のフォントだけ変更したい場合は`Table.font`をキーにして以下のように設定する
    
    <pre class="prettyprint"><code>UIManager.put("Table.font", new FontUIResource(font));

</code></pre>
- 各コンポーネントのキーは、`UIManager`から`UIDefaults`のキー一覧が作成可能
    
    <pre class="prettyprint"><code>// キー一覧の作成例
    import javax.swing.UIManager;
    
    class Test {
      public static void main(String[] args) {
        UIManager.getLookAndFeelDefaults().forEach((key, value) -&gt; System.out.println(key));
      }
    }
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
- `MetalLookAndFeel`で使用されているボールドフォントは、以下のように変更可能
    - [MetalLookAndFeelで太字フォントを使用しない](https://ateraimemo.com/Swing/BoldMetal.html)
        
        <pre class="prettyprint"><code>UIManager.put("swing.boldMetal", Boolean.FALSE);

</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
- `JComboBox#setFont(...)`で使用するフォントのサイズを変更しても、`JComboBox`自体のサイズが更新されない
    - [JCombobox doesn't get resized according to font size change](https://bugs.openjdk.java.net/browse/JDK-5006246)
        
        <pre class="prettyprint"><code>combo.setFont(font);
        // 以下回避方法
        combo.setPrototypeDisplayValue(null); // null:default?
        // or combo.firePropertyChange("prototypeDisplayValue", 0, 1); // 0, 1:dummy
</code></pre>

<!-- dummy comment line for breaking list -->
- - - -
特定のインスタンスだけ、`LookAndFeel`などを変更しても常に独自のフォントを設定したい場合、`JComponent#updateUI()`をオーバーライドして設定する方法もあります。

<pre class="prettyprint"><code>JLabel label = new JLabel() {
  @Override public void updateUI() {
    super.updateUI();
    setFont(...);
  }
};
</code></pre>

## 参考リンク
- [Re: setFont に関して](http://java-house.jp/ml/archive/j-h-b/049474.html)

<!-- dummy comment line for breaking list -->

## コメント
- `JFileChooser`インスタンス化前に上記ソースを実行すると `ConcurrentModificationException`がスローされるのですが... 「`JDK1.4.2_02`」プロパティーが動的に変化するとしたらあまり有効な方法でないのでは? -- *MT* 2003-12-24 (水) 14:22:15
- 割と手軽なので重宝するのですが、ちゃんとスレッド処理考えたほうがいいのかもしれませんね。 -- *aterai* 2003-12-25 (木) 20:06:15
- レスありがとうございます _ _)m とりあえず `Container` を辿りながら含まれている `Component` 毎に `setFont` 呼ぶようなユーティリティ用意してしのいでいます＾＾； -- *MT* 2003-12-26 (金) 16:20:14
- `UIManager`のリストにないコンポーネント（独自で作成したボタンなどのコンポーネント）なども追加すると変更が適用されるのでしょうか？ -- *mari* 2004-01-22 (木) 10:53:29
- `JButton`などの`Swing`コンポーネントを継承していれば変更されるはずです。 -- *aterai* 2004-01-22 (木) 11:46:40
- レスありがとうございます。その場合、独自のコンポーネントを追加すると、そのコンポーネントのみ変更が適用されますか？`Panel`を追加したら全ての`panel`に適用されてしまってうまくいきませんでした。良い方法があれば教えてください。 -- *mari* 2004-01-23 (金) 10:24:45
- すべてのコンポーネントに一々設定するのが面倒な場合のための方法なので、上記の場合は使用する意味が無いですね(^^;。ある独自コンポーネントのみフォントを変えたいのなら、コンストラクタなどで普通に`setFont`すればいいのでないかと思うのですが、どうなんでしょう？そうではなく、あるパネル以下のコンポーネントのフォントを一気に変えたいということなんでしょうか？ -- *aterai* 2004-01-23 (金) 12:13:27
- たびたびすみません。全体のフォントの大きさをツールバーの選択によって変化させるようにしたいです。フォントだけ変化させたいのですが、コンストラクタなどで勝手に`setBackground`しているコンポーネントは`Look and Feel`で設定しているデフォルトの`background`に変わってしまいました。また`new`するわけではないので、そのコンポーネントのみのデフォルトをどこかで設定できたらいいなー、と思いました。`Look and Feel`でも`panel`だったら`panel`全ての設定しかできないのでしょうか？有効な方法があれば教えてください。よろしくお願いいたします。 -- *mari* 2004-01-23 (金) 14:05:47
- `Look and Feel`で変更するのではなく、イベントリスナーを作って実装するのはどうでしょう？はずしてるかもしれませんが、とりあえずサンプル置いておきます。初期値はコンストラクタで指定してます。ツールバーじゃなくてメニューで、フォントを切り替えてます。コンボボックスを切り替えたときにサイズがおかしいのは愛嬌ということで…。 -- *aterai* 2004-01-23 (金) 15:39:27
    - [EventListenerを実装して独自イベント作成](https://ateraimemo.com/Swing/EventListener.html)
- すばらしいサンプルありがとうございます！参考にさせていただきました☆フォントの変更を`Look and Feel`で行って、残りの描画できなかった背景色などを`PropertyChangeListener`を実装して描画しなおす、という方法も考えたのですが、こちらでも問題ないでしょうか？主題から外れてしまって申し訳ありません・・・。 -- *mari* 2004-01-26 (月) 09:56:38
- 次のネタ用にイベント作っただけなので、`PropertyChangeListener`使うのはまったく問題ないと思います。むしろちゃんと`JavaBeans`にして`PropertyChangeListener`使うほうがいいかもしれません(^^;。 -- *aterai* 2004-01-26 (月) 12:54:00
- `updateUI()`をオーバーライドする方法を追記。 -- *aterai* 2013-02-26 (火) 16:15:09
- `Nimbus`の場合は、この方法では駄目でした。バグのようです。回避策は、`UIManager.getLookAndFeelDefaults().put("defaultFont", new Font(Font.SANS_SERIF, 0, 20));`をフレームを`new`する前に実行する事でした。 参考：[swing - Java: Altering UI fonts (Nimbus) doesn't work! - Stack Overflow](https://stackoverflow.com/questions/949353/java-altering-ui-fonts-nimbus-doesnt-work) -- *匿名* 2013-05-25 (土) 09:14:08
    - 情報ありがとうございます。これバグだとすると修正されるのかな？(仕様になりそうな気がしますが) 参考のリンク先にある[Nimbus Defaults](http://jasperpotts.com/blogfiles/nimbusdefaults/nimbus.html)一覧が便利ですね(チュートリアル[Nimbus Defaults (The Java™ Tutorials > Creating a GUI With JFC/Swing > Modifying the Look and Feel)](https://docs.oracle.com/javase/tutorial/uiswing/lookandfeel/_nimbusDefaults.html)にも転載されています)。このサイトでは、そちらを参考にして`NimbusLookAndFeel`の色をまとめて変換するサンプル([NimbusLookAndFeelのカラーパレット](https://ateraimemo.com/Swing/NimbusColorPalette.html))を作成しています。 -- *aterai* 2013-05-26 (日) 00:51:21

<!-- dummy comment line for breaking list -->
