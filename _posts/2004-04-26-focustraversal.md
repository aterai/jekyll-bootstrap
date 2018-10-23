---
layout: post
category: swing
folder: FocusTraversal
title: Focusの移動
tags: [FocusTraversalPolicy, Focus]
author: aterai
pubdate: 2004-04-26T12:45:56+09:00
description: FocusTraversalPolicyを使って、KBD{Tab}キーなどによるフォーカスの移動を制御します。
image: https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTNE9BAwqI/AAAAAAAAAaM/57d2rzX7ixk/s800/FocusTraversal.png
comments: true
---
## 概要
`FocusTraversalPolicy`を使って、<kbd>Tab</kbd>キーなどによるフォーカスの移動を制御します。

{% download https://lh4.googleusercontent.com/_9Z4BYR88imo/TQTNE9BAwqI/AAAAAAAAAaM/57d2rzX7ixk/s800/FocusTraversal.png %}

## サンプルコード
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
    return order.get(order.size() - 1);
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

## 解説
上記のサンプルでは、`FocusTraversalPolicy`を使用してキー入力によるフォーカスの移動を制御しています。また、`JRadioButton`で以下のような`FocusTraversalPolicy`に切り替えが可能です。

- `Default`
    - `JPanel`のデフォルトは、`null`
    - 実際のキー入力によるフォーカスの移動には、このパネルの親(`JFrame`)に設定されている`FocusTraversalPolicy`を使用
- `Custom`
    - [Merlinの魔術: フォーカス、フォーカス、フォーカス](https://www.ibm.com/developerworks/jp/java/library/j-mer07153/)からの引用
    - <kbd>Tab</kbd>キーを押していくと、東西南北の順でボタンのフォーカスが移動(<kbd>Shift+Tab</kbd>キーでは逆順)
    - `4`つの`JButton`以外には、<kbd>Tab</kbd>キーでフォーカスは移動しない
- `Layout`
    - 以下のように`LayoutFocusTraversalPolicy`(`LayoutFocusTraversalPolicy`は`Swing`のデフォルト、`AWT`のデフォルトは`DefaultFocusTraversalPolicy`)の`accept`メソッドをオーバーライドして、中央の`JTextArea`(通常、`JTextArea`などから次のコンポーネントにフォーカス移動する場合は、<kbd>Ctrl+Tab</kbd>)が編集不可の場合は、これに<kbd>Tab</kbd>キーなどでフォーカスが移動しないように設定

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>frame.setFocusTraversalPolicy(new LayoutFocusTraversalPolicy() {
  @Override protected boolean accept(Component c) {
    if (c instanceof JTextComponent) {
      return ((JTextComponent) c).isEditable();
    } else {
      return super.accept(c);
    }
  }
};
</code></pre>

## 参考リンク
- [AWTフォーカス・サブシステム](https://docs.oracle.com/javase/jp/8/docs/api/java/awt/doc-files/FocusSpec.html)
- [Merlinの魔術: フォーカス、フォーカス、フォーカス](https://www.ibm.com/developerworks/jp/java/library/j-mer07153/)
- [Windowを開いたときのフォーカスを指定](https://ateraimemo.com/Swing/DefaultFocus.html)
- [FocusTraversalKeysに矢印キーを追加してフォーカス移動](https://ateraimemo.com/Swing/FocusTraversalKeys.html)

<!-- dummy comment line for breaking list -->

## コメント
