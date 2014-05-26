---
layout: post
title: Focusの移動
category: swing
folder: FocusTraversal
tags: [FocusTraversalPolicy, Focus]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2004-04-26

## Focusの移動
`FocusTraversalPolicy`を使って、<kbd>Tab</kbd>キーなどによるフォーカスの移動を制御します。

{% download %}

![screenshot](https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTNE9BAwqI/AAAAAAAAAaM/57d2rzX7ixk/s800/FocusTraversal.png)

### サンプルコード
<pre class="prettyprint"><code>final JButton nb = new JButton("NORTH");
final JButton sb = new JButton("SOUTH");
final JButton wb = new JButton("WEST");
final JButton eb = new JButton("EAST");
add(new JScrollPane(textarea));
add(nb, BorderLayout.NORTH);
add(sb, BorderLayout.SOUTH);
add(wb, BorderLayout.WEST);
add(eb, BorderLayout.EAST);
FocusTraversalPolicy policy = new FocusTraversalPolicy() {
  //private final List&lt;Component&gt; order = Arrays.asList(
  //    new Component[] {eb, wb, sb, nb});
  private final List&lt;? extends Component&gt; order = Arrays.asList(eb, wb, sb, nb);
  @Override public Component getFirstComponent(Container focusCycleRoot) {
    return order.get(0);
  }
  @Override public Component getLastComponent(Container focusCycleRoot) {
    return order.get(order.size()-1);
  }
  @Override public Component getComponentAfter(
      Container focusCycleRoot, Component aComponent) {
    int i = order.indexOf(aComponent);
    return order.get((i + 1) % order.size());
  }
  @Override public Component getComponentBefore(
      Container focusCycleRoot, Component aComponent) {
    int i = order.indexOf(aComponent);
    return order.get((i - 1 + order.size()) % order.size());
  }
  @Override public Component getDefaultComponent(Container focusCycleRoot) {
    return order.get(0);
  }
};
frame.setFocusTraversalPolicy(policy);
//setFocusTraversalPolicyProvider(true);
//setFocusTraversalPolicy(policy);
</code></pre>

### 解説
上記のサンプルでは、`FocusTraversalPolicy`を使用することで、キー入力によるフォーカスの移動を制御しています。また、ラジオボタンで以下のような`FocusTraversalPolicy`に切り替えることができます。

- `Default`
    - `JPanel`のデフォルトは、`null`
    - 実際のキー入力によるフォーカスの移動には、このパネルの親(`JFrame`)に設定されている`FocusTraversalPolicy`が使用される

<!-- dummy comment line for breaking list -->

- `Custom`
    - [Merlinの魔術: フォーカス、フォーカス、フォーカス](http://www.ibm.com/developerworks/jp/java/library/j-mer07153/)からの引用
    - <kbd>Tab</kbd>キーを押していくと、東西南北の順でボタンのフォーカスが移動(<kbd>Shift+Tab</kbd>キーでは逆順)
    - `4`つの`JButton`以外には、<kbd>Tab</kbd>キーでフォーカスは移動しない

<!-- dummy comment line for breaking list -->

- `Layout`
    - 以下のように`LayoutFocusTraversalPolicy`(`LayoutFocusTraversalPolicy`は`Swing`のデフォルト、`AWT`のデフォルトは`DefaultFocusTraversalPolicy`)の`accept`メソッドをオーバーライドして、中央の`JTextArea`(通常、`JTextArea`などから次のコンポーネントにフォーカス移動する場合は、<kbd>Ctrl+Tab</kbd>)が編集不可の場合は、これに<kbd>Tab</kbd>キーなどでフォースが移動しないように設定している

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>frame.setFocusTraversalPolicy(new LayoutFocusTraversalPolicy() {
  @Override protected boolean accept(Component c) {
    if(c instanceof JTextComponent &amp;&amp; !((JTextComponent)c).isEditable()) {
      return false;
    }else{
      return super.accept(c);
    }
    //return (c==textarea)?false:super.accept(c);
  }
});
</code></pre>

### 参考リンク
- [AWT フォーカスサブシステム](http://docs.oracle.com/javase/jp/7/api/java/awt/doc-files/FocusSpec.html)
- [Merlinの魔術: フォーカス、フォーカス、フォーカス](http://www.ibm.com/developerworks/jp/java/library/j-mer07153/)
- [Windowを開いたときのフォーカスを指定](http://terai.xrea.jp/Swing/DefaultFocus.html)
- [FocusTraversalKeysに矢印キーを追加してフォーカス移動](http://terai.xrea.jp/Swing/FocusTraversalKeys.html)

<!-- dummy comment line for breaking list -->

### コメント
